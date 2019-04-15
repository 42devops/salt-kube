{% from "vault/map.jinja" import vault with context %}

configure_vault_server:
  file.managed:
    - name: /etc/vault.d/vault.hcl
    - makedirs: True
    - source: salt://vault/files/vault.json.jinja
    - template: jinja
    - watch_in:
      - service: vault_service_running
    - require_in:
      - service: vault_service_running

make_ensure_vault_data_dir:
  file.directory:
    - name: /var/vault/data
    - makedirs: True

vault_service_running:
  service.running:
    - name: vault
    - enable: True
    - reload: True