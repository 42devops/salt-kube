{% set local_install = salt.caasp_pillar.get('cni:local_install') %}
{% set version = salt.caasp_pillar.get('cni:version') %}
{% set hash_sha256 = salt.pillar.get('cni:hash_sha256') %}
flannel-tar:
  archive.extracted:
    - user: root
    - name: /usr/local/src/flannel
    - makedirs: True
    - enforce_toplevel: False
{% if local_install %}
    - source: salt://kube-cni/flannel/files/flannel-{{ version }}-linux-amd64.tar.gz
{% else %}
    - source: https://github.com/coreos/flannel/releases/download/{{ version }}/flannel-{{ version }}-linux-amd64.tar.gz
{% endif %}
    - options: v
    - source_hash: sha256={{ hash_sha256 }}
    - archive_format: tar
    - if_missing: /usr/local/src/flannel/flanneld

flannel-symlink:
  file.symlink:
    - name: /usr/local/bin/flanneld
    - target: /usr/local/src/flannel/flanneld
    - force: true
    - watch:
        - archive: flannel-tar
    - require:
        - archive: flannel-tar

mk-docker-opts-symlink:
  file.symlink:
    - name: /usr/local/bin/mk-docker-opts.sh
    - target: /usr/local/src/flannel/mk-docker-opts.sh
    - force: true
    - watch:
        - archive: flannel-tar
    - require:
        - archive: flannel-tar

/usr/local/bin/remove-docker0.sh:
  file.managed:
    - source: salt://kube-cni/flannel/files/remove-docker0.sh
    - user: root
    - group: root
    - mode: 711
    - makedirs: True


/etc/default/flannel:
  file.managed:
    - source: salt://kube-cni/flannel/files/flannel.jinja
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - makedirs: True

configure_flannel_service:
  file.managed:
    - name: /etc/systemd/system/flannel.service
    - source: salt://kube-cni/flannel/files/service.flannel.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: configure_flannel_service
    - require:
      - file: /etc/default/flannel
      - file: configure_flannel_service
      - file: /usr/local/bin/remove-docker0.sh

flannel_running:
  service.running:
    - name: flannel
    - enable: True
    - reload: True
    - watch:
      - file: configure_flannel_service
    - require:
      - file: configure_flannel_service