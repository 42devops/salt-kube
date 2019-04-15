{%- set main_dir = '/opt/etcd' %}

etcd-backup-script:
  file.managed:
    - name: {{ main_dir }}/etcd-backup.sh
    - source: salt://crontab/files/etcd-backup.sh.jinja
    - mode: 711
    - makedirs: True
    - user: root
    - group: root
    - template: jinja

etcd-backup-cronjob:
  cron.present:
    - name: {{ main_dir }}/etcd-backup.sh
    - user: root
    - minute: '0'
    - hour: '*/4'
