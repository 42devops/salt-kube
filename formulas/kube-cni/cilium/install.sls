{% if 'kube-master' in salt['grains.get']('roles', []) %}
{% if salt['pillar.get']('cni:plugin', 'flannel').lower() == "cilium" %}

{% from '_macros/kubectl.jinja' import kubectl, kubectl_apply_dir_template with context %}


{{ kubectl_apply_dir_template("salt://kube-cni/cilium/files/cilium/",
                              "/etc/kubernetes/addons/cilium/") }}

/etc/kubernetes/policy:
  file.directory:
    - mode: 0755
    - makedirs: True

{% else %}

dns-dummy:
  cmd.run:
    - name: echo "Cilium addon not enabled in config"

{% endif %}
{% endif %}