# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

vault-service-init-file-managed:
  file.managed:
    - name: {{ vault.service.path }}
    - source: {{ vault.service.source }}
    - template: jinja
{% if grains.init == 'upstart' %}
  cmd.run:
    - name: initctl reload-configuration
    - onchanges:
      - file: vault-service-init-file-managed
{% endif -%}

vault-service-init-service-running:
  service.running:
    - name: vault
    - enable: True
    - watch:
      - archive: vault-package-install-archive-extracted
      - file: vault-service-init-file-managed
