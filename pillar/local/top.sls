local:
  'os:Ubuntu':
      - match: grain
      - common.packages_ubuntu
  'os:(RedHat|CentOS)':
      - match: grain_pcre
      - common.packages_centos
  '*':
    - common
    - salt.salt
    - salt.minion
    - salt.mine
    - salt.beacons
    - salt.schedule
  'roles:salt':
    - match: grain
    - salt.master
    - salt.ssh
    - vault
  'roles:ca':
    - match: grain
    - kube.ca
  'roles:(salt|kube-master|kube-minion|etcd)':
    - match: grain_pcre
    - kube.ca-cert
    - kube.params
  'roles:kube-minion':
    - match: grain
    - docker
  'roles:etcd':
    - match: grain
    - etcd
