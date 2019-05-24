include:
  - cert.require
  - kube-common
  - .install

{% from '_macros/certs.jinja' import certs with context %}
{{ certs("kube-scheduler", pillar['ssl']['kube_scheduler_crt'], pillar['ssl']['kube_scheduler_key']) }}


kube-scheduler-config:
  file.managed:
    - name: {{ pillar['paths']['kube_scheduler_config'] }}
    - source: salt://kube-config/files/kubeconfig.jinja
    - makedirs: True
    - template: jinja
    - require:
      - caasp_retriable: {{ pillar['ssl']['kube_scheduler_crt'] }}
    - defaults:
        user: 'default-admin'
        client_certificate: {{ pillar['ssl']['kube_scheduler_crt'] }}
        client_key: {{ pillar['ssl']['kube_scheduler_key'] }}


# Wait for the kube-scheduler to be healthy.
kube-scheduler-health-check:
  caasp_retriable.retry:
    - target:     caasp_http.wait_for_successful_query
    - name:       http://localhost:10251/healthz
    - wait_for:   10
    - retry:
        attempts: 3
    - status:     200
    - opts:
        http_request_timeout: 10
    - onchanges:
        - service: kube-scheduler