#!/bin/sh
function docker_monitoring {
  if ! timeout 60 docker ps > /dev/null; then
    echo "Docker daemon failed!"
    systemctl restart docker
    ## Wait for a while, as we don't want to kill it again before it is really up.
    sleep 100
  fi
}

docker_monitoring | while IFS= read -r line; do echo "$(date) $line"; done >> /var/log/health-monitor.log