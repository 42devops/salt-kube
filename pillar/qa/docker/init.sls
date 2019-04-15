{% set username = salt['vault'].read_secret('secret/docker','username') %}
{% set password = salt['vault'].read_secret('secret/docker','password') %}
docker:
  pkg: 'docker'
  version: '18.06.3-ce'
  hash: 'a979d9a952fae474886c7588da692ee00684cb2421d2c633c7ed415948cf0b10'
  daemon:
    storage-driver: 'btrfs'
    log-driver: 'json-file'
    log-max-size: '2g'
registries:
  - url: "172.21.0.76:5001"
    auth: {{'%s:%s' | format(username, password)}}
  - url: "172.21.0.76:5000"
    auth: {{'%s:%s' | format(username, password)}}
