include:
  - cert.require
  - kube-common
  - .install

{% from '_macros/certs.jinja' import certs with context %}
{{ certs('node:' + grains['nodename'],
         pillar['ssl']['kubelet_crt'],
         pillar['ssl']['kubelet_key'],
         o = 'system:nodes') }}

kubeconfig:
  file.managed:
    - name: {{ pillar['paths']['kubelet_config'] }}
    - source: salt://kube-config/files/kubeconfig.jinja
    - template: jinja
    - makedirs: True
    - require:
      - sls: kube-common
      - caasp_retriable: {{ pillar['ssl']['kubelet_crt'] }}
    - defaults:
        user: 'default-admin'
        client_certificate: {{ pillar['ssl']['kubelet_crt'] }}
        client_key: {{ pillar['ssl']['kubelet_key'] }}

ensure_pod_manifests_directory:
  file.directory:
    - name: /etc/kubernetes/manifests
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

kubelet-config:
  file.managed:
    - name: /etc/kubernetes/kubelet-config.yaml
    - source: salt://kubelet/files/kubelet-config.yaml.jinja
    - template: jinja
    - require:
      - sls: kube-common

kubelet_running:
  service.running:
    - name: kubelet
    - enable: True
    - reload: True
    - watch:
      - file: configure-kubelet-service
    - require:
      - file: configure-kubelet-service

# Wait for the kubelet to be healthy.
kubelet-health-check:
  caasp_retriable.retry:
    - target:     caasp_http.wait_for_successful_query
    - name:       http://localhost:10248/healthz
    - wait_for:   10
    - retry:
        attempts: 3
    - status:     200
    - opts:
        http_request_timeout: 30
    - onchanges:
        - service: kubelet

{% if salt.caasp_pillar.get('registries') %}
/var/lib/kubelet/config.json:
  file.managed:
    - source: salt://docker/files/config.json.jinja
    - template: jinja
    - makedirs: True
{% endif %}