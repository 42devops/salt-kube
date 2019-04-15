{% set package_url = salt.caasp_pillar.get('kubernetes:lookup:package_url') %}
{% set version = salt.caasp_pillar.get('kubernetes:lookup:version') %}
{% set hash = salt.caasp_pillar.get('kubernetes:lookup:kube-apiserver:hash') %}
{% set local_install = salt.caasp_pillar.get('kubernetes:lookup:local_install') %}

kube_apiserver-package-download:
  file.managed:
    - name: /usr/local/bin/kube-apiserver
{%- if local_install %}
    - source: salt://kube-apiserver/files/kube-apiserver
{% else %}
    - source: {{ package_url }}/{{ version }}/bin/linux/amd64/kube-apiserver
{% endif %}
    - source_hash: sha256={{ hash }}
    - mode: 711
    - skip_verify: True
    - unless: test -f /usr/local/bin/kube-apiserver

configure-kube_apiserver-service:
  file.managed:
    - name: /etc/systemd/system/kube-apiserver.service
    - source: salt://kube-apiserver/files/service.kube-apiserver.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube_apiserver-service

configure_encryption_file:
  file.managed:
    - name: /var/lib/kubernetes/encryption-config.yaml
    - source: salt://kube-apiserver/files/encryption-config.yaml.jinja
    - template: jinja
    - makedirs: True
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube_apiserver-service

configure_audit_policy_file:
  file.managed:
    - name: /var/lib/kubernetes/audit-policy-minimal.yaml
    - source: salt://kube-apiserver/files/audit-policy-minimal.yaml.jinja
    - template: jinja
    - makedirs: True
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube_apiserver-service


kube_apiserver_running:
  service.running:
    - name: kube-apiserver
    - enable: True
    - reload: True
    - watch:
      - file: configure-kube_apiserver-service
    - require:
      - file: configure-kube_apiserver-service