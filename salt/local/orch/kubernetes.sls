{%- set default_batch = 5 %}

{# the number of etcd masters that should be in the cluster #}
{%- set num_etcd_members = 3 %}

# Ensure all the nodes are marked with a 'bootstrap_in_progress' flag
set-bootstrap-in-progress-flag:
  salt.function:
    - tgt: 'roles:(ca|salt|kube-master|kube-minion|etcd)'
    - tgt_type: grain_pcre
    - name: grains.setval
    - saltenv: local
    - arg:
      - bootstrap_in_progress
      - true

sync-pillar:
  salt.runner:
    - name: saltutil.sync_pillar
    - saltenv: local

update-pillar:
  salt.function:
    - tgt: '*'
    - name: saltutil.refresh_pillar
    - saltenv: local
    - require:
      - sync-pillar

update-grains:
  salt.function:
    - tgt: '*'
    - name: saltutil.refresh_grains
    - saltenv: local
    - require:
      - sync-pillar

update-mine:
  salt.function:
    - tgt: '*'
    - name: mine.update
    - saltenv: local
    - require:
      - update-pillar
      - update-grains

update-modules:
  salt.function:
    - tgt: '*'
    - name: saltutil.sync_all
    - saltenv: local
    - kwarg:
        refresh: True
    - require:
      - update-mine

salt-master-setup:
  salt.state:
    - tgt: 'roles:salt'
    - tgt_type: grain
    - saltenv: local
    - sls:
      - salt.master

salt-minion-sls:
  salt.state:
    - tgt: '*'
    - saltenv: local
    - sls:
      - salt.minion

update-mine-two:
  salt.function:
    - tgt: '*'
    - name: mine.update
    - saltenv: local

ca-setup:
  salt.state:
    - tgt: 'roles:ca'
    - tgt_type: grain
    - saltenv: local
    - sls:
      - caserver.initca

update-pillar-two:
  salt.function:
    - tgt: '*'
    - name: saltutil.refresh_pillar
    - saltenv: local
    - require:
      - ca-setup

update-mine-tree:
  salt.function:
    - tgt: '*'
    - name: mine.update
    - saltenv: local
    - require:
      - ca-setup


generate-sa-key:
  salt.state:
    - tgt: 'roles:ca'
    - tgt_type: grain
    - saltenv: local
    - sls:
      - kube-common.generate-serviceaccount-key
    - require:
      - ca-setup

update-pillars:
  salt.function:
    - tgt: '*'
    - name: saltutil.refresh_pillar
    - saltenv: local
    - require:
      - ca-setup


update-mine-again:
  salt.function:
    - tgt: '*'
    - name: mine.update
    - saltenv: local
    - require:
      - generate-sa-key

# setup {{ num_etcd_members }} etcd masters
etcd-setup:
  salt.state:
    - tgt: 'roles:etcd'
    - tgt_type: grain
    - saltenv: local
    - sls:
      - etcd
    - batch: {{ num_etcd_members }}
    - require:
      - update-mine-again

kube-master-setup:
  salt.state:
    - tgt: 'roles:kube-master'
    - tgt_type: grain
    - saltenv: local
    - highstate: True
    - batch: {{ default_batch }}
    - require:
      - ca-setup
      - generate-sa-key
      - update-mine-again

kube-minion-setup:
  salt.state:
    - tgt: 'roles:kube-minion'
    - tgt_type: grain
    - highstate: True
    - saltenv: local
    - batch: {{ default_batch }}
    - require:
      - kube-master-setup


# we must start CNI before any other pods, as nodes will be NotReady until
# the CNI DaemonSet is loaded and running...
services-setup:
  salt.state:
    - tgt: 'roles:kube-master'
    - tgt_type: grain
    - saltenv: local
    - sls:
      - kube-cni

# Wait for deployments to have the expected number of pods running.
super-master-wait-for-services:
  salt.state:
    - tgt: 'roles:kube-master'
    - tgt_type: grain
    - saltenv: local
    - sls:
      - kube-addons.coredns.deployment-wait
    - require:
      - services-setup

running-all-state-apply:
  salt.state:
    - tgt: '*'
    - highstate: True
    - require:
      - ca-setup
      - kube-master-setup
      - kube-minion-setup
# Set the bootstrap complete in all the nodes where we really succeeded
# (if `admin-wait-for-services` fails, we will not set the flag)
set-bootstrap-complete-flag:
  salt.function:
    - tgt: 'bootstrap_in_progress:true'
    - tgt_type: grain
    - saltenv: local
    - name: grains.setval
    - arg:
      - bootstrap_complete
      - true

# Ensure we remove the bootstrap_in_progress in all the nodes where it was set
# NOTE: we must remove this flag even if the orchestration fails
clear-bootstrap-in-progress-flag:
  salt.function:
    - tgt: 'bootstrap_in_progress:true'
    - tgt_type: grain
    - saltenv: local
    - name: grains.delval
    - arg:
      - bootstrap_in_progress
    - kwarg:
        destructive: True
