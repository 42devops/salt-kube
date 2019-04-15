{% set package_url =     "https://github.com/coreos/etcd/releases/download" %}
{% set etcd_package = salt.caasp_pillar.get('etcd:pkg') %}
{% set etcd_version = salt.caasp_pillar.get('etcd:version') %}
{% set etcd_hash = salt.caasp_pillar.get('etcd:hash') %}
{% set etcd_datadir = salt.caasp_pillar.get('etcd:data_dir') %}
{% set local_install = salt.caasp_pillar.get('etcd:local_install') %}

etcd_group_user:
  group.present:
    - name: etcd
    - system: True
  user.present:
    - name: etcd
    - createhome: False
    - groups:
      - etcd
    - require:
      - group: etcd

etcd_package_download:
  file.managed:
    - name: /tmp/{{ etcd_package }}-{{ etcd_version }}.tar.gz
{%- if local_install %}
    - source: salt://etcd/files/{{ etcd_package }}-{{ etcd_version }}-linux-amd64.tar.gz
{% else %}
    - source: {{ package_url }}/{{ etcd_package }}-{{ etcd_version }}-linux-amd64.tar.gz
{% endif %}
    - source_hash: sha256={{ etcd_hash }}
    - skip_verify: True
    - unless: test -f /usr/local/bin/etcd

etcd_package_extract:
  cmd.wait:
    - name: tar xzf /tmp/{{ etcd_package }}-{{ etcd_version }}.tar.gz -C /tmp
    - watch:
      - file: etcd_package_download

etcd_install:
  file.rename:
    - name: /usr/local/bin/etcd
    - source: /tmp/{{ etcd_package }}-{{ etcd_version }}-linux-amd64/etcd
    - makedirs: True
    - watch:
      - cmd: etcd_package_extract
    - require:
      - cmd: etcd_package_extract

etcdctl_install:
  file.rename:
    - name: /usr/local/bin/etcdctl
    - source: /tmp/{{ etcd_package }}-{{ etcd_version }}-linux-amd64/etcdctl
    - makedirs: True
    - watch:
      - cmd: etcd_package_extract
    - require:
      - cmd: etcd_package_extract

etcd_data_path:
  file.directory:
    - name: {{ etcd_datadir }}
    - makedirs: True
    - user: etcd
    - group: etcd
    - require:
      - group: etcd
      - user: etcd

configure_etcd_service:
  file.managed:
    - name: /etc/systemd/system/etcd.service
    - source: salt://etcd/files/service.etcd.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: configure_etcd_service

etcd_running:
  service.running:
    - name: etcd
    - enable: True
    - reload: True
    - watch:
      - file: configure_etcd_service
    - require:
      - file: configure_etcd_service