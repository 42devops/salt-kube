{# In Kubernetes, /etc/hosts is mounted in from the host. file.blockreplace fails on this #}
{% if 'no_hosts' not in salt['grains.get']('roles', []) %}
/etc/hosts:
  file.blockreplace:
    # If markers are changed, also update etc-hosts/update-pre-reboot.sls
    - marker_start: "#-- start Salt managed hosts - DO NOT MODIFY --"
    - marker_end:   "#-- end Salt managed hosts --"
    - source:       salt://etc-hosts/hosts.jinja
    - template:     jinja
    - append_if_not_found: True
{% else %}
{# See https://github.com/saltstack/salt/issues/14553 #}
etc-hosts-dummy:
  cmd.run:
    - name: "echo saltstack bug 14553"
{% endif %}