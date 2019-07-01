packages:
  pkgs:
    wanted:
      - git
      - less
      - curl
      - openssl
      - ipvsadm
      - socat
    required:
      pkgs:
        - wget
        - git
        - yum-plugin-versionlock

  remote_pkgs:
    python-M2Crypto: 'ftp://ftp.pbone.net/mirror/forensics.cert.org/fedora/cert/20/x86_64/python-M2Crypto-0.26.0-0.x86_64.rpm'