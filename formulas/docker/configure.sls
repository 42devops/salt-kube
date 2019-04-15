/etc/docker/daemon.json:
  file.managed:
    - source: salt://docker/files/daemon.json.jinja
    - template: jinja
    - makedirs: True

network.ipv4.ip_forward:
  sysctl.present:
    - name: net.ipv4.ip_forward
    - value: 1

docker-reload-config:
  cmd.run:
    - name: systemctl reload docker
    - onchanges:
      - file: /etc/docker/daemon.json

{% if salt.caasp_pillar.get('registries') %}
add-the-docker-registries-auth-config:
  file.managed:
    - name: /root/.docker/config.json
    - source: salt://docker/files/config.json.jinja
    - template: jinja
    - makedirs: True
{% endif %}