include:
  - kubectl

/etc/kubernetes/config:
  file.managed:
    - source: salt://kube-common/files/config.jinja
    - template: jinja
    - makedirs: True