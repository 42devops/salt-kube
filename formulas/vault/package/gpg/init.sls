# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

vault-package-gpg-file-managed:
  file.managed:
    - name: /opt/vault/hashicorp.asc
    - contents: |
        {{ vault.hashicorp_gpg_key | indent(8) }}
    - makedirs: True

vault-package-gpg-pkg-installed:
  pkg.installed:
    - name: {{ vault.gpg_pkg }}

vault-package-gpg-cmd-run-import:
  cmd.run:
    - name: gpg --import /opt/vault/hashicorp.asc
    - unless: gpg --list-keys {{ vault.hashicorp_key_id }}

vault-package-gpg-file-managed-signature:
  file.managed:
    - name: /opt/vault/{{ vault.version }}_SHA256SUMS.sig
    - source: https://releases.hashicorp.com/vault/{{ vault.version }}/vault_{{ vault.version }}_SHA256SUMS.sig
    - skip_verify: True
    - makedirs: True

vault-package-gpg-cmd-run-verify:
  cmd.run:
    - name: gpg --verify /opt/vault/{{ vault.version }}_SHA256SUMS.sig /opt/vault/{{ vault.version }}_SHA256SUMS
    - onchanges:
      - file: vault-package-install-file-managed
      - file: vault-package-gpg-file-managed-signature
