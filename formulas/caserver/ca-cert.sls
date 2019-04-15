include:
  - cert.require

{{ pillar['ssl']['ca_dir'] }}:
  file.directory:
    - makedirs: True
    - user: root
    - group: root
    - mode: 755

{{ pillar['ssl']['ca_file'] }}:
  x509.pem_managed:
    - text: {{ salt['mine.get']('roles:ca', 'ca.crt', tgt_type='grain').values()[0]['/etc/pki/ca.crt']|replace('\n', '') }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: {{ pillar['ssl']['ca_dir'] }}
