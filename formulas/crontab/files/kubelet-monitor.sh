#!/bin/sh
SLEEP_SECONDS=10
max_seconds=15
function kubelet_monitoring {
    echo "Wait for 2 minutes for kubelet to be functional"
    local -r max_seconds=10
    local output=""
    if ! output=$(curl -m "${max_seconds}" -f -s -S http://127.0.0.1:10248/healthz 2>&1); then
        echo $output
        echo "Kubelet is unhealthy!"
        systemctl restart kubelet
        sleep 60
    fi
}


kubelet_monitoring | while IFS= read -r line; do echo "$(date) $line"; done >> /var/log/health-monitor.log