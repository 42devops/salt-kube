/usr/local/bin/kubectl:
  file.managed:
    - source: salt://kubectl/files/kubectl
    - user: root
    - group: root
    - mode: 711

