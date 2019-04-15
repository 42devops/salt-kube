include:
  - kube-config

{% if 'kube-master' in salt['grains.get']('roles', []) %}
{% if salt.caasp_pillar.get('addons:dns', True) %}

{% from '_macros/kubectl.jinja' import kubectl, kubectl_apply_dir_template with context %}


{{ kubectl_apply_dir_template("salt://kube-addons/coredns/manifests/",
                              "/etc/kubernetes/addons/dns/") }}

{% else %}

dns-dummy:
  cmd.run:
    - name: echo "DNS addon not enabled in config"

{% endif %}
{% endif %}
