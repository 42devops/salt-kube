---
/sys/fs/bpf:
  mount.mounted:
    - devices: bpffs
    - fstype: bpf

/etc/kubernetes/manifests:
  file.directory:
    - mode: 0755
    - makedirs: True

config-files:
  file.managed:
    - mode: 0755
    - template: jinja
    - names:
      - /etc/kubernetes/manifests/cilium-config.yml:
        - source: salt://kube-cni/cilium/files/cilium-config.yml.j2
      - /etc/kubernetes/manifests/cilium-crb.yml:
        - source: salt://kube-cni/cilium/files/cilium-config.yml.j2
      - /etc/kubernetes/manifests/cilium-cr.yml:
        - source: salt://kube-cni/cilium/files/cilium-config.yml.j2
      - /etc/kubernetes/manifests/cilium-ds.yml:
        - source: salt://kube-cni/cilium/files/cilium-config.yml.j2
      - /etc/kubernetes/manifests/cilium-sa.yml:
        - source: salt://kube-cni/cilium/files/cilium-config.yml.j2