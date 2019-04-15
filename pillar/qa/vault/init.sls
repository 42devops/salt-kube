vault:
  overrides:
    version: '1.0.3'
    keybase_users:
      - xiangxu
    secret_shares: 5
    secret_threshold: 2
    config:
      listener:
        tcp:
          address: '0.0.0.0:8200'
          tls_cert_file: '/etc/pki/minion.crt'
          tls_key_file: '/etc/pki/minion.key'
      backend:
        file:
          path: /var/vault/data
vault.verify: False
