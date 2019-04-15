{% set package_url = salt.caasp_pillar.get('kubernetes:lookup:package_url') %}
{% set version = salt.caasp_pillar.get('kubernetes:lookup:version') %}
{% set hash = salt.caasp_pillar.get('kubernetes:lookup:kube-scheduler:hash') %}
{% set local_install = salt.caasp_pillar.get('kubernetes:lookup:local_install') %}

kube-scheduler-package-download:
  file.managed:
    - name: /usr/local/bin/kube-scheduler
{%- if local_install %}
    - source: salt://kube-scheduler/files/kube-scheduler
{% else %}
    - source: {{ package_url }}/{{ version }}/bin/linux/amd64/kube-scheduler
{% endif %}
    - source_hash: sha256={{ hash }}
    - mode: 711
    - skip_verify: True
    - unless: test -f /usr/local/bin/kube-scheduler

configure-kube-scheduler-service:
  file.managed:
    - name: /etc/systemd/system/kube-scheduler.service
    - source: salt://kube-scheduler/files/service.kube-scheduler.conf.jinjia
    - template: jinja
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube-scheduler-service

configure_scheduler-kubeconfig:
  file.managed:
    - name: /etc/kubernetes/kube-scheduler.yaml
    - source: salt://kube-scheduler/files/kube-scheduler.yaml.jinja
    - template: jinja
    - makedirs: True
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube-scheduler-service

kube-scheduler_running:
  service.running:
    - name: kube-scheduler
    - enable: True
    - reload: True
    - watch:
      - file: configure-kube-scheduler-service
    - require:
      - file: configure-kube-scheduler-service