---
---
projectatomic-ppa:
  pkgrepo.managed:
    - ppa: projectatomic/ppa
    - require_in:
      - pkg: cri-o
cri-o:
  pkg.installed:
    - refresh: True
    - skip_verify: True
