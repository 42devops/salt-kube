/opt/cni/bin:
  file.directory:
    - mode: 0755
    - makedirs: True

/etc/cni/net.d:
  file.directory:
    - mode: 0755
    - makedirs: True

uarchive_cni_plugins:
  archive.extracted:
    - name: "/opt/cni/bin"
    - source: salt://kube-cni/cni/files/cni-plugins-linux-amd64-v0.8.1.tgz"

