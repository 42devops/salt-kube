salt:
    # config for salt-minion
  minion:
    master: 172.21.0.142
    startup_states: highstate
    log_level: info
    multiprocessing: false
    saltenv: prod
    mine_interval: 5
    pillarenv_from_saltenv: True
