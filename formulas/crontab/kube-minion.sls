
{%- if salt.caasp_pillar.get('cri:chosen') == 'docker' %}
docker-monitor-script:
  file.managed:
    - name: /opt/docker-monitor.sh
    - source: salt://crontab/files/docker-monitor.sh
    - mode: 711
monitor_docker_ps:
  cron.absent:
    - name: /opt/docker-monitor.sh
    - user: root
    - minute: '*/3'
{%- endif %}
kubelet-monitor-script:
  file.managed:
    - name: /opt/kubelet-monitor.sh
    - source: salt://crontab/files/kubelet-monitor.sh
    - mode: 711



monitor_kubelet_ps:
  cron.absent:
    - name: /opt/kubelet-monitor.sh
    - user: root
    - minute: '*/3'
