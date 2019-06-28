include:
  - packages
  - motd
  - sysctl
  - salt.minion
  - etc-hosts

# # disable systsem-resolved
# systemd-resolved-stop:
#   cmd.run:
#     - name: systemctl stop systemd-resolved
#     - onlyif: systemctl is-active --quiet systemd-resolved