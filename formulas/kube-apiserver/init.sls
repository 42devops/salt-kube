include:
  - caserver.ca-cert
  - cert
  - kube-common.serviceaccount-key
  - .install
  - kube-config

{% set netiface = salt.caasp_pillar.get('hw:netiface') %}
{%- set this_ip = grains['ip4_interfaces'][netiface][0] %}

kube-apiserver-wait-port-6443:
  caasp_retriable.retry:
    - target:     caasp_http.wait_for_successful_query
    - name:       {{ 'https://' + this_ip + ':6443' }}/healthz
    - wait_for:   10
    - retry:
        attempts: 3
    - ca_bundle:  {{ pillar['ssl']['ca_file'] }}
    - status:     401
    - opts:
        http_request_timeout: 10
    - watch:
      - service: kube-apiserver

# {%- from '_macros/kubectl.jinja' import kubectl with context %}

# A simple check: we can do a simple query (a `get nodes`)
# to the API server
# {{ kubectl("check-kubectl-get-nodes", "get nodes") }}
