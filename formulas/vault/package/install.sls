# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

vault-package-install-group-present:
  group.present:
    - name: vault
    - system: True

vault-package-install-user-present:
  user.present:
    - name: vault
    - system: True
    - gid_from_name: True
    - home: /var/lib/vault

vault-package-install-file-directory:
  file.directory:
    - name: /opt/vault/bin
    - makedirs: True

vault-package-install-data-directory:
  file.directory:
    - name: /opt/vault/data
    - makedirs: True

vault-package-install-file-managed:
  file.managed:
    - name: /opt/vault/{{ vault.version }}_SHA256SUMS
    - source: https://releases.hashicorp.com/vault/{{ vault.version }}/vault_{{ vault.version }}_SHA256SUMS
    - skip_verify: True
    - makedirs: True

vault-package-install-service-dead:
  service.dead:
    - name: vault
    - onchanges:
      - file: vault-package-install-file-managed
    - onlyif: test -f /etc/systemd/system/vault.service

vault-package-install-archive-extracted:
  archive.extracted:
    - name: /opt/vault/bin
    - source: salt://vault/files/vault_{{ vault.version }}_{{ vault.platform }}.zip
    - source_hash: https://releases.hashicorp.com/vault/{{ vault.version }}/vault_{{ vault.version }}_SHA256SUMS
    - source_hash_name: vault_{{ vault.version }}_{{ vault.platform }}.zip
    - enforce_toplevel: False
    - overwrite: True
    - onchanges:
      - file: vault-package-install-file-managed

vault-package-install-file-symlink:
  file.symlink:
    - name: /usr/local/bin/vault
    - target: /opt/vault/bin/vault
    - force: true

vault-package-install-cmd-run:
  cmd.run:
    - name: setcap cap_ipc_lock=+ep /opt/vault/bin/vault
    - onchanges:
      - archive: vault-package-install-archive-extracted
