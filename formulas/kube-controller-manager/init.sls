include:
  - caserver.ca-cert
  - cert
  - kube-common.serviceaccount-key
  - .install

{% from '_macros/certs.jinja' import certs with context %}
{{ certs("kube-controller-manager", pillar['ssl']['kube_controller_manager_crt'], pillar['ssl']['kube_controller_manager_key'])}}

kube-controller-manager-config:
  file.managed:
    - name: {{ pillar['paths']['kube_controller_manager_config'] }}
    - source: salt://kube-config/files/kubeconfig.jinja
    - template: jinja
    - require:
      - caasp_retriable: {{ pillar['ssl']['kube_controller_manager_crt'] }}
    - defaults:
        user: 'default-admin'
        client_certificate: {{ pillar['ssl']['kube_controller_manager_crt'] }}
        client_key: {{ pillar['ssl']['kube_controller_manager_key'] }}