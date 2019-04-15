systemd-timesyncd_running:
  service.running:
    - name: systemd-timesyncd
    - enable: True