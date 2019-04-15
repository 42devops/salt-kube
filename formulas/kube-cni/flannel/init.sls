include:
  - .install

{% set netiface = salt.caasp_pillar.get('hw:netiface') %}
{%- set this_ip = grains['ip4_interfaces'][netiface][0] %}

flannel-wait-port-10290:
  caasp_retriable.retry:
    - target:     caasp_http.wait_for_successful_query
    - name:       {{ 'http://' + this_ip + ':10290' }}/healthz
    - wait_for:   10
    - retry:
        attempts: 3
    - status:     200
    - opts:
        http_request_timeout: 10
    - watch:
      - service: flannel