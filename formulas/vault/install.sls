{% from "vault/map.jinja" import vault, vault_service with context %}

install_vault_binary:
  archive.extracted:
    - name: /usr/local/src/vault
{%- if vault.local_install %}
    - source: salt://vault/files/vault_{{ vault.version }}_linux_amd64.zip
    - source_hash: {{ vault.source_hash }}
{% else %}
    - source: {{ vault.repo_base_url }}/{{ vault.version }}/vault_{{ vault.version }}_linux_amd64.zip
    - source_hash: {{ vault.repo_base_url }}/{{ vault.version }}/vault_{{ vault.version }}_SHA256SUMS
{% endif %}
    - archive_format: zip
    - if_missing: /usr/local/src/vault/vault
    - source_hash_update: True
    - enforce_toplevel: False

vault-symlink:
  file.symlink:
    - name: /usr/local/bin/vault
    - target: /usr/local/src/vault/vault
    - force: true
    - watch:
        - archive: install_vault_binary
    - require:
        - archive: install_vault_binary

configure-vault-service:
  file.managed:
    - name: /etc/systemd/system/vault.service
    - source: salt://vault/files/vault.service
  module.run:
    - name: service.systemctl_restart
    - onchanges:
      - file: configure-vault-service