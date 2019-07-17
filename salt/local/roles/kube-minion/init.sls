include:
  - swap.disable
  - caserver.ca-cert
  - kube-cni
{%- if salt.caasp_pillar.get('cri:chosen') == 'docker' %}
  - crontab.kube-minion
  - docker
{%- endif %}
{%- if salt.caasp_pillar.get('cri:chosen') == 'crio' %}
  - crio
{%- endif %}
  - cert
  - kubelet
  - kube-proxy