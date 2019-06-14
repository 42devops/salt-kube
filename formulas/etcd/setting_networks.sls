{% if salt.caasp_pillar.get('cni:plugin') == 'flannel' %}
{% set etcd_networks_keys = salt.caasp_pillar.get('kubernetes:lookup:kube-controller-manager:cluster_cidr') %}
{% set key_domain = pillar['internal_infra_domain'] %}
{% if 'etcd' in salt['grains.get']('roles', []) %}
{% set cluster_ep = [] -%}
{% for server, addr in salt['mine.get']('roles:etcd', 'network.ip_addrs', tgt_type='grain').items() -%}
{% if cluster_ep.append( "https://" + addr[0] + ":2379") -%}
{% endif -%}
{% endfor -%}

setting_etcdkeys:
  cmd.run:
    - name: |
          /usr/local/bin/etcdctl \
          --ca-file {{ pillar['ssl']['ca_file'] }} \
          --cert-file {{ pillar['ssl']['crt_file'] }} \
          --key-file  {{ pillar['ssl']['key_file'] }} \
          --endpoints  {{ cluster_ep|join(',') }} \
          mk /{{ key_domain }}/network/config \
          "{\"Network\": \"{{ etcd_networks_keys }}\" }"
    - unless: |
          /usr/local/bin/etcdctl \
          --ca-file {{ pillar['ssl']['ca_file'] }} \
          --cert-file {{ pillar['ssl']['crt_file'] }} \
          --key-file  {{ pillar['ssl']['key_file'] }} \
          --endpoints  {{ cluster_ep|join(',') }} \
          get /{{ key_domain }}/network/config
{% endif %}
{% endif %}