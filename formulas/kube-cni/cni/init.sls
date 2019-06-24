{% set cni_plugins_version = salt.caasp_pillar.get('cni:cni_plugins_version') %}
{% set cni_plugins_hash = salt.caasp_pillar.get('cni:cni_plugins_hash') %}
/opt/cni/bin:
  file.directory:
    - mode: 0755
    - makedirs: True

/etc/cni/net.d:
  file.directory:
    - mode: 0755
    - makedirs: True

upload_cni_plugins:
  file.managed:
    - name: /tmp/cni-plugins-linux-amd64-{{ cni_plugins_version }}.tgz
    - source: salt://kube-cni/cni/files/cni-plugins-linux-amd64-{{ cni_plugins_version }}.tgz
    - source_hash: sha256={{ cni_plugins_hash }}
    - unless: test -f /opt/cni/bin/portmap


uarchive_cni_plugins:
  cmd.wait:
    - name: tar xzf /tmp/cni-plugins-linux-amd64-{{ cni_plugins_version }}.tgz -C /opt/cni/bin
    - watch:
      - file: upload_cni_plugins
    - require:
      - file: upload_cni_plugins