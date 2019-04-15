salt:
  master:
    log_level: info
    open_mode: True
    state_output: mixed
    presence_events: True
    worker_threads: 20
    zmq_backlog: 2000
    timeout: 20
    auto_accept: True
    peer:
      .*:
        - vault.generate_token
        - x509.sign_remote_certificate
      stage:
        - state.apply
        - state.sls
    peer_run:
      .*:
        - vault.generate_token
        - x509.sign_remote_certificate
    file_roots:
      prod:
        - /srv/salt/prod
        - /srv/salt/prod/roles
        - /srv/formulas
    pillar_roots:
      prod:
        - /srv/pillar/prod
    runner_dirs:
      - /srv/_runners
    reactor:
      - 'salt/presence/change':
        - /srv/reactor/presence.sls
        - /srv/reactor/etc-hosts.sls
      - 'salt/beacon/*/network_settings/*':
        - /srv/reactor/etc-hosts.sls
      - 'salt/minion/*/start':
        - /srv/reactor/etc-hosts.sls
        - /srv/reactor/sync-modules.sls
        - /srv/reactor/update-mine.sls
        - /srv/reactor/update-roles.sls
      - 'salt/job/*/ret/*':
        - /srv/reactor/alert_onfailure_highstate.sls
