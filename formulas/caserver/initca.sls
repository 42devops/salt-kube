{%- import  'caserver/map.jinja' as ca -%}
include:
  - cert.require

{% if not salt['file.directory_exists']('/etc/pki/ca.key') and not salt['file.directory_exists']('/etc/pki/ca.crt') %}
/etc/pki/ca.key:
  x509.private_key_managed:
    - bits: 4096
    - backup: True
    - require:
      - file: /etc/pki

/etc/pki/ca.crt:
  x509.certificate_managed:
    - signing_private_key: /etc/pki/ca.key
    - CN: {{ ca.common_name }}
    - C: {{ ca.country }}
    - ST: {{ ca.state }}
    - L: {{ ca.locality }}
    - O: {{ ca.organization }}
    - OU: {{ ca.organization_unit }}
    - basicConstraints: "critical CA:true"
    - keyUsage: "critical cRLSign, keyCertSign"
    - subjectKeyIdentifier: hash
    - authorityKeyIdentifier: keyid,issuer:always
    - days_valid: 3650
    - days_remaining: 0
    - backup: True
    - require:
      - file: /etc/pki
      - x509: /etc/pki/ca.key
{% endif %}

ensure /etc/pki/ca.key:
  file.managed:
    - name: /etc/pki/ca.key
    - replace: false
    - user: root
    - group: root
    - mode: 400

ensure /etc/pki/ca.crt:
  file.managed:
    - name: /etc/pki/ca.crt
    - replace: false
    - user: root
    - group: root
    - mode: 644

