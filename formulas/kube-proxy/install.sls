{% set package_url = salt.caasp_pillar.get('kubernetes:lookup:package_url') %}
{% set version = salt.caasp_pillar.get('kubernetes:lookup:version') %}
{% set hash = salt.caasp_pillar.get('kubernetes:lookup:kube-proxy:hash') %}
{% set local_install = salt.caasp_pillar.get('kubernetes:lookup:local_install') %}

kube-proxy-package-download:
  file.managed:
    - name: /usr/local/bin/kube-proxy
{%- if local_install %}
    - source: salt://kube-proxy/files/kube-proxy
{% else %}
    - source: {{ package_url }}/{{ version }}/bin/linux/amd64/kube-proxy
{% endif %}
    - source_hash: sha256={{ hash }}
    - mode: 711
    - skip_verify: True
    - unless: test -f /usr/local/bin/kube-proxy

configure-kube-proxy-service:
  file.managed:
    - name: /etc/systemd/system/kube-proxy.service
    - source: salt://kube-proxy/files/service.kube-proxy.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube-proxy-service

configure_proxy-kubeconfig:
  file.managed:
    - name: /etc/kubernetes/kube-proxy.yaml
    - source: salt://kube-proxy/files/kube-porxy-config.yaml.jinja
    - template: jinja
    - makedirs: True
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kube-proxy-service