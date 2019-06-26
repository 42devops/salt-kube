{% if 'kube-minion' in salt['grains.get']('roles', []) %}
sys-fs-bpf-files:
  file.managed:
    - name: "/etc/systemd/system/sys-fs-bpf.mount"
    - source: salt://kube-cni/cilium/files/sys-fs-bpf.mount

sys-fs-bpf-start:
  service.running:
    - name: sys-fs-bpf.mount
    - enable: True
    - reload: True
{% endif %}