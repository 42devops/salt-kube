{{ pillar['paths']['service_account_key'] }}:
  x509.pem_managed:
    - text: {{ salt['mine.get']('roles:ca', 'sa.key', tgt_type='grain').values()[0]['/etc/pki/sa.key']|replace('\n', '') }}
    - user: root
    - group: root
    - mode: 0444
