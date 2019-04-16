# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

vault-config-clean-file-absent:
  file.absent:
    - name: /etc/vault
