{% if 'kube-master' in salt['grains.get']('roles', []) %}
{% if salt['pillar.get']('istio:enable', 'false') %}

{% from '_macros/kubectl.jinja' import kubectl, kubectl_apply_dir_template, kubectl_apply_file with context %}


{{ kubectl_apply_dir_template("salt://istio/files/istio-crd/",
                              "/etc/kubernetes/addons/istio/") }}

{{ kubectl_apply_file("salt://istio/files/istio-auth.yaml", "/etc/kubernetes/addons/istio/istio-auth.yaml") }}

{% else %}

dns-dummy:
  cmd.run:
    - name: echo "istio addon not enabled in config"

{% endif %}
{% endif %}