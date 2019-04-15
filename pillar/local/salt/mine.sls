mine_functions:
  network.ip_addrs:
    - eth1
  network.interfaces:
    - eth1
  network.default_route: []
  grains.item:
    - id
    - os
    - fqdn
    - fqdn_ip4
    - ipv4
    - roles
    - nodename
    - host
# {%- if "ca" in salt['grains.get']('roles', []) -%}
#   ca.crt:
#     mine_function: x509.get_pem_entries
#     glob_path: /etc/pki/ca.crt
#   sa.key:
#     mine_function: x509.get_pem_entries
#     glob_path: /etc/pki/sa.key
# {%- endif -%}