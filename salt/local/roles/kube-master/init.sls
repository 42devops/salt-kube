include:
  - caserver.ca-cert
  - cert
  - kube-apiserver
  - kube-controller-manager
  - kube-scheduler
  - kube-addons.coredns
{% if salt['pillar.get']('cni:plugin', 'flannel').lower() == "cilium" %}
  - kube-cni.cilium
{% endif %}