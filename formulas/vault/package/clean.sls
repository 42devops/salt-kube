# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

include:
  - .gpg.clean

vault-package-clean-file-absent:
  file.absent:
    - name: /opt/vault

vault-package-clean-file-absent-data:
  file.absent:
    - name: /var/lib/vault

vault-package-clean-file-absent-link:
  file.absent:
    - name: /usr/local/bin/vault

vault-package-clean-user-absent:
  user.absent:
    - name: vault

vault-package-clean-group-absent:
  group.absent:
    - name: vault
