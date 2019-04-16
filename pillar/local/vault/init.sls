vault:
  version: 1.1.1
  platform: linux_amd64
  dev_mode: False
  verify_download: False
  verify: False
  config:
    ui: "true"
    storage:
      type: "etcd"
      etcd_api: "v3"
      ha_enabled: "true"
      tls_ca_file: "/etc/pki/trust/anchors/DevOps_CA.crt"
      tls_cert_file: '/etc/pki/minion.crt'
      tls_key_file: '/etc/pki/minion.key'
    listener:
      type: "tcp"
      address: "0.0.0.0:8200"
      tls_cert_file: '/etc/pki/minion.crt'
      tls_key_file: '/etc/pki/minion.key'
      tls_disable: false
    default_lease_ttl: 768h
    max_lease_ttl: 768h
    api_addr: "https://0.0.0.0:8200"
