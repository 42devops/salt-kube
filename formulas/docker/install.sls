{% set package_url =     "https://download.docker.com/linux/static/stable/x86_64/" %}
{% set docker_package = salt.caasp_pillar.get('docker:pkg') %}
{% set docker_version = salt.caasp_pillar.get('docker:version') %}
{% set docker_hash = salt.caasp_pillar.get('docker:hash') %}
{% set local_install = salt.caasp_pillar.get('docker:local_install', true) %}

docker-package-download:
  file.managed:
    - name: /tmp/{{ docker_package }}-{{ docker_version }}.tgz
{%- if local_install %}
    - source: salt://docker/files/{{ docker_package }}-{{ docker_version }}.tgz
{% else %}
    - source: {{ package_url }}{{ docker_package }}-{{ docker_version }}.tgz
{% endif %}
    - source_hash: sha256={{ docker_hash }}
    - skip_verify: True
    - unless: test -f /usr/local/bin/docker

docker-package-extract:
  cmd.wait:
    - name: tar xzf /tmp/{{ docker_package }}-{{ docker_version }}.tgz -C /tmp
    - watch:
      - file: docker-package-download
    - require:
      - file: docker-package-download

docker-install:
  cmd.wait:
    - name: cp -r /tmp/docker/docker* /usr/local/bin
    - unless: test -f /usr/local/bin/docker
    - watch:
      - cmd: docker-package-extract
    - require:
      - cmd: docker-package-extract

configure-mk-docker-flannelnetwork:
  file.managed:
    - name: /usr/local/bin/mk-docker-opts.sh
    - source: salt://docker/files/mk-docker-opts.sh
    - mode: 711

configure-docker-service:
  file.managed:
    - name: /etc/systemd/system/docker.service
    - source: salt://docker/files/service.docker.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: configure-docker-service

docker_running:
  service.running:
    - name: docker
    - enable: True
    - reload: True
    - watch:
      - file: configure-docker-service
    - require:
      - file: configure-docker-service