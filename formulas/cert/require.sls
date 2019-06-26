/etc/pki:
  file.directory:
    - user: root
    - group: root
    - mode: 755

ensure /etc/pki/issued_certs:
  file.directory:
    - name: /etc/pki/issued_certs
    - user: root
    - group: root
    - mode: 755

/etc/salt/minion.d/signing_policies.conf:
  file.managed:
    - source: salt://caserver/files/signing_policies.conf

start salt-minion service:
  service.running:
    - name: salt-minion
    - enable: True
    - listen:
      - file: /etc/salt/minion.d/signing_policies.conf
