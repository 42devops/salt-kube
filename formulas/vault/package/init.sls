# -*- coding: utf-8 -*-
# vim: ft=sls syntax=yaml softtabstop=2 tabstop=2 shiftwidth=2 expandtab autoindent

{% from "vault/map.jinja" import vault with context %}

include:
  - .install
  {%- if vault.verify_download %}
  - .gpg
  {%- endif %}
