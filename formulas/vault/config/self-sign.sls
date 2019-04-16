# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context -%}

vault-config-self-signed-pkg-installed:
  pkg.installed:
    - name: openssl

vault-config-self-signed-cmd-script:
  cmd.script:
    - source: salt://vault/files/cert-gen.sh.j2
    - template: jinja
    - args: {{ vault.self_signed_cert.hostname }} {{ vault.self_signed_cert.password }}
    - cwd: /etc/vault
    - creates: /etc/vault/{{ vault.self_signed_cert.hostname }}.pem
