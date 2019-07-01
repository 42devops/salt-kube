include:
  - swap.disable
  - caserver.ca-cert
  - kube-cni
{%- if salt.caasp_pillar.get('cri:chosen') == 'docker' %}
  - docker
{%- endif %}
{%- if salt.caasp_pillar.get('cri:chosen') == 'crio' %}
  - crio
{%- endif %}
  - cert
  - kubelet
  - kube-proxy
  - crontab.kube-minon