{% set package_url = salt.caasp_pillar.get('kubernetes:lookup:package_url') %}
{% set version = salt.caasp_pillar.get('kubernetes:lookup:version') %}
{% set hash = salt.caasp_pillar.get('kubernetes:lookup:kube-controller-manager:hash') %}
{% set local_install = salt.caasp_pillar.get('kubernetes:lookup:local_install') %}

kube-controller-manager-package-download:
  file.managed:
    - name: /usr/local/bin/kube-controller-manager
{%- if local_install %}
    - source: salt://kube-controller-manager/files/kube-controller-manager
{% else %}
    - source: {{ package_url }}/{{ version }}/bin/linux/amd64/kube-controller-manager
{% endif %}
    - source_hash: sha256={{ hash }}
    - mode: 711
    - skip_verify: True
    - unless: test -f /usr/local/bin/kube-controller-manager

configure-kube-controller-manager-service:
  file.managed:
    - name: /etc/systemd/system/kube-controller-manager.service
    - source: salt://kube-controller-manager/files/service.kube-controller-manager.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube-controller-manager-service

# configure_controller-manager-kubeconfig:
#   file.managed:
#     - name: /var/lib/kubernetes/kube-controller-manager.kubeconfig
#     - source: salt://kube-controller-manager/files/kube-controller-manager.kubeconfig.jinja
#     - template: jinja
#     - makedirs: True
#   module.run:
#     - name: service.systemctl_reload
#     - onchanges:
#       - file: configure-kube-controller-manager-service

kube-controller-manager_running:
  service.running:
    - name: kube-controller-manager
    - enable: True
    - reload: True
    - watch:
      - file: configure-kube-controller-manager-service
      - x509: {{ pillar['paths']['service_account_key'] }}
    - require:
      - file: configure-kube-controller-manager-service
      - x509: {{ pillar['paths']['service_account_key'] }}