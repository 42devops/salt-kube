sysctl:
  lookup:
    pkg: procps-ng
    config:
      location: '/etc/sysctl.d'
  params:
    fs.file-max:
      value: 100000
      config: fs.conf
    vm.swappiness: 20
chrony:
  ntpservers:
    - '0.pool.ntp.org'
    - '1.pool.ntp.org'
    - '2.pool.ntp.org'
    - '3.pool.ntp.org'
hw:
  #the default interface
  netiface: 'eth1'