{% import_yaml 'roles.yml' as roles_settings %}

{% set server_roles = salt.caasp_pillar.parser(roles_settings) %}

{% for server, roles in server_roles.items() %}

"{{ server }}_setting_roles":
  salt.function:
    - tgt: '{{ server }}'
    - tgt_type: ipcidr
    - saltenv: prod
    - name: grains.setval
    - arg:
      - roles
      - {{ roles }}
{% endfor %}

update-pillar:
  salt.function:
    - tgt: '*'
    - name: saltutil.refresh_pillar
    - saltenv: prod


update-grains:
  salt.function:
    - tgt: '*'
    - name: saltutil.refresh_grains
    - saltenv: prod


update-mine:
  salt.function:
    - tgt: '*'
    - name: mine.update
    - saltenv: prod
    - require:
      - update-pillar
      - update-grains

update-modules:
  salt.function:
    - tgt: '*'
    - name: saltutil.sync_all
    - saltenv: prod
    - kwarg:
        refresh: True
    - require:
      - update-mine
