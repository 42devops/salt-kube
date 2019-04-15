# Generic Updates
set_grains:
  salt.function:
    - tgt: 'roles:*-gateway'
    - tgt_type: grain
    - name: grains.delval
    - saltenv: prod
    - arg:
      - maintain

update-grains:
  salt.function:
    - tgt: 'roles:*-gateway'
    - tgt_type: grain
    - name: saltutil.refresh_grains
    - saltenv: prod

reload_frontend-gateway:
  salt.state:
    - tgt: 'roles:frontend-gateway'
    - tgt_type: grain
    - sls:
      - frontend-gateway
    - saltenv: prod

reload_internet-gateway:
  salt.state:
    - tgt: 'roles:internet-gateway'
    - tgt_type: grain
    - sls:
      - internet-gateway
    - saltenv: prod

reload_intranet-gateway:
  salt.state:
    - tgt: 'roles:intranet-gateway'
    - tgt_type: grain
    - sls:
      - intranet-gateway
    - saltenv: prod