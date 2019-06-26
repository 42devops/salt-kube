local:
  '*':
    - common
  'roles:salt':
    - match: grain
    - salt-master
  'roles:ca':
    - match: grain
    - caserver
  'roles:etcd':
    - match: grain
    - etcd-cluster
  'roles:kube-master':
    - match: grain
    - kube-master
  'roles:kube-minion':
    - match: grain
    - kube-minion
