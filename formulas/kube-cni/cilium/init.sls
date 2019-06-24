sys-fs-bpf-files:
  file.managed:
    - name: "/etc/systemd/system/sys-fs-bpf.mount"
    - source: salt://kube-cni/cilium/files/sys-fs-bpf.mount

sys-fs-bpf-start:
  service.running:
    - name: sys-fs-bpf.mount
    - enable: True
    - reload: True


{% if 'kube-master' in salt['grains.get']('roles', []) %}
{% if salt['pillar.get']('cni:plugin', 'flannel').lower() == "cilium" %}

{% from '_macros/kubectl.jinja' import kubectl, kubectl_apply_dir_template with context %}


{{ kubectl_apply_dir_template("salt://kube-cni/cilium/files/cilium/",
                              "/etc/kubernetes/addons/cilium/") }}

{% else %}

dns-dummy:
  cmd.run:
    - name: echo "Cilium addon not enabled in config"

{% endif %}
{% endif %}