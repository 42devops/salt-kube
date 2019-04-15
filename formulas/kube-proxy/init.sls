include:
  - kube-common
  - .install

{% from '_macros/certs.jinja' import certs with context %}
{{ certs('kube-proxy',
         pillar['ssl']['kube_proxy_crt'],
         pillar['ssl']['kube_proxy_key'],
         o = 'system:nodes') }}

{{ pillar['paths']['kube_proxy_config'] }}:
  file.managed:
    - source: salt://kube-config/files/kubeconfig.jinja
    - template: jinja
    - require:
      - sls: kube-common
      - caasp_retriable: {{ pillar['ssl']['kube_proxy_crt'] }}
    - defaults:
        user: 'default-admin'
        client_certificate: {{ pillar['ssl']['kube_proxy_crt'] }}
        client_key: {{ pillar['ssl']['kube_proxy_key'] }}

kube-proxy_running:
  service.running:
    - name: kube-proxy
    - enable: True
    - reload: True
    - watch:
      - file: configure-kube-proxy-service
    - require:
      - file: configure-kube-proxy-service