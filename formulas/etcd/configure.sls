# note: this will be used to run etcdctl client command
/etc/sysconfig/etcdctl:
  file.managed:
    - source: salt://etcd/files/etcdctl.conf.jinja
    - template: jinja
    - user: etcd
    - group: etcd
    - mode: 644
    - makedirs: True
    - require:
      - file: /usr/local/bin/etcdctl
      - user: etcd
      - group: etcd

