
{% set plugin = salt['pillar.get']('cni:plugin', 'flannel').lower() %}

#######################
# flannel CNI plugin
#######################

{% if plugin == "flannel" %}
include:
  - kube-cni/flannel
{% endif %}

{% if plugin == "cilium" %}
include:
  - kube-cni/cni
  - kube-cni/cilium
{% endif %}