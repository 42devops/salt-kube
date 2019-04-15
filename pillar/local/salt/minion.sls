salt:
    # config for salt-minion
  minion:
    master: salt
    startup_states: highstate
    log_level: info
    multiprocessing: false
    saltenv: local
    mine_interval: 5
    pillarenv_from_saltenv: True