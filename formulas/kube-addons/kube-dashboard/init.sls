include:
  - kube-config

{% if 'kube-master' in salt['grains.get']('roles', []) %}
{% if salt.caasp_pillar.get('addons:kube-dashboard', True) %}

{% from '_macros/kubectl.jinja' import kubectl, kubectl_apply_dir_template with context %}


{{ kubectl_apply_dir_template("salt://kube-addons/kube-dashboard/manifests/",
                              "/etc/kubernetes/addons/kube-dashboard/") }}

{% else %}

dns-dummy:
  cmd.run:
    - name: echo "kube-dashboard addon not enabled in config"

{% endif %}
{% endif %}