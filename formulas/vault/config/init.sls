# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

{%- if not vault.dev_mode %}
include:
  - .config
  {%- if vault.self_signed_cert.enabled %}
  - .self-sign
  {%- endif %}
{%- endif %}
