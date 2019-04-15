
{% set plugin = salt['pillar.get']('cni:plugin', 'flannel').lower() %}

#######################
# flannel CNI plugin
#######################

{% if plugin == "flannel" %}
include:
  - kube-cni/flannel
{% endif %}