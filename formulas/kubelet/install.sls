{% set package_url = salt.caasp_pillar.get('kubernetes:lookup:package_url') %}
{% set version = salt.caasp_pillar.get('kubernetes:lookup:version') %}
{% set hash = salt.caasp_pillar.get('kubernetes:lookup:kubelet:hash') %}
{% set local_install = salt.caasp_pillar.get('kubernetes:lookup:local_install') %}

# {% if grains['os_family'] == "Suse" %}
# suse_network_repo_added:
#   pkgrepo.managed:
#     - humanname: SuSe Network management (SLE_12_SP3)
#     - mirrorlist:  https://download.opensuse.org/repositories/network:utilities/SLE_12_SP3
#     - gpgcheck: 0
#     - enabled: true
#     - refresh: true
# {% endif %}

ipvsadm:
  pkg.installed:
    - install_recommends: False

kubelet-package-download:
  file.managed:
    - name: /usr/local/bin/kubelet
{%- if local_install %}
    - source: salt://kubelet/files/kubelet
{% else %}
    - source: {{ package_url }}/{{ version }}/bin/linux/amd64/kubelet
{% endif %}
    - source_hash: sha256={{ hash }}
    - mode: 711
    - skip_verify: True
    - unless: test -f /usr/local/bin/kubelet

configure-kubelet-service:
  file.managed:
    - name: /etc/systemd/system/kubelet.service
    - source: salt://kubelet/files/service.kubelet.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-kubelet-service
