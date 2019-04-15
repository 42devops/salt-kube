# {% if grains['os_family'] == "Suse" %}
# suse_salt_repo_added:
#   pkgrepo.managed:
#     - humanname: Software configuration management (SLE_12_SP3)
#     - mirrorlist: http://download.opensuse.org/repositories/devel:/tools:/scm/SLE_12_SP3/
#     - gpgcheck: 1
#     - gpgkey: http://download.opensuse.org/repositories/devel:/tools:/scm/SLE_12_SP3/repodata/repomd.xml.key
#     - enabled: true
#     - refresh: true
# {% endif %}
include:
  - motd
  - salt.minion
  - etc-hosts
  - .file_limits
  - timesync