prod:
  '*':
    - common
    - salt.salt
    - salt.minion
    - salt.mine
    - salt.beacons
    - salt.schedule
    - kube.params
    - kube.ca-cert
  'roles:salt':
    - match: grain
    - salt.master
    - salt.ssh
    - vault
  'roles:ca':
    - match: grain
    - kube.ca
  'roles:kube-minion':
    - match: grain
    - docker
  'roles:kube-master':
    - match: grain
    - docker
  'roles:etcd':
    - match: grain
    - etcd
