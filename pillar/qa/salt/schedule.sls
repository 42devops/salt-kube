schedule:
  highstate:
    function: state.apply
    minutes: 10
  update_grains:
    function: event.fire
    maxrunning: 1
    minutes: 10
    jid_include: true
    args:
    - {'force_refresh': True}
    - grains_refresh