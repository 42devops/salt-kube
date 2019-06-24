{% from "packages/map.jinja" import packages with context %}
{% set wanted_rem_pkgs = packages.remote_pkgs %}
### REMOTE PKGS to install directly from a remote URL. Must be a deb/rpm file
{% if wanted_rem_pkgs != {} %}
remote_packages:
  pkg.installed:
    - sources:
      {% for package, url in wanted_rem_pkgs.items() %}
      -  {{ package }}: {{ url }}
      {% endfor %}
{% endif %}