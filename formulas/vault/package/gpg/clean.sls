# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

vault-package-gpg-clean-cmd-run:
  cmd.run:
    - name: gpg --batch --yes --delete-key {{ vault.hashicorp_key_id }}
    - onlyif: gpg --list-keys {{ vault.hashicorp_key_id }}

vault-package-gpg-clean-file-absent:
  file.absent:
    - name: /opt/vault/hashicorp.asc

vault-package-gpg-clean-file-absent-checksum:
  file.absent:
    - name: /opt/vault/{{ vault.version }}_SHA256SUMS

vault-package-gpg-clean-file-absent-signature:
  file.absent:
    - name: /opt/vault/{{ vault.version }}_SHA256SUMS.sig
