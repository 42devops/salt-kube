{% set username="admin" %}
{% set password="admin" %}
docker:
  local_install: True
  pkg: 'docker'
  version: '18.06.3-ce'
  hash: '183b31b001e7480f3c691080486401aa519101a5cfe6e05ad01b9f5521c4112d'
  daemon:
    storage-driver: overlay
    log-driver: json-file
    log-max-size: 500m
registries:
  - url: "172.16.10.10:5001"
    auth: {{'%s:%s' | format(username, password)}}
  - url: "172.16.10.10:5000"
    auth: {{'%s:%s' | format(username, password)}}
