kubernetes:
  lookup:
    version: v1.14.1
    local_install: True
    package_url: "https://storage.googleapis.com/kubernetes-release/release"
    kube-apiserver:
      hash: 76309590e505ea0d3650c8328ad6c841fdc145f56992393ee4ab6ffe374b2e57
      services_cidr: '10.24.0.0/16'
      cluster_ip: '10.24.0.1'
      encryption_key: q7wCru4rcMib0pQl5RX6QavKFZNMGNTfk6jNZwWC5es=
      apiserver_port: '6443'
      PUBLIC_ADDRESS: '172.16.10.10'
      external_fqdn: ''
    kube-controller-manager:
      hash: dacd36fe5ac33a84f69acb8996d274432bcad0501162771e8a9b3ff1f4ed1fa5
      cluster_cidr: '10.200.0.0/16'
    kubelet:
      hash: 1d74192caab21d12e13b3d64e34b6ce4275e25d78022f59a2be6996ee8195863
      port: '10250'
      # infra container to use instead of downloading gcr.io/google_containers/pause
      # pod_infra_container_image: 172.21.3.76:5000/k8s/pause-amd64:3.1
      compute-resources:
        kube:
          cpu: ''
          memory: ''
          ephemeral-storage: ''
          # example:
          # cpu: 100m
          # memory: 100M
          # ephemeral-storage: 1G
        system:
          cpu: ''
          memory: ''
          ephemeral-storage: ''
      eviction-hard: ''
      # example:
      # eviction-hard: memory.available<500M
      # Drain timeout, in seconds
      drain-timeout: '600'
      # DNS service IP and some other stuff (must be inside the 'services_cidr')
      dns:
        cluster_ip:     '10.24.0.2'
        domain:         'cluster.local'
        replicas:       '3'
    # kubernetes feature gates to be enabled
    # https://kubernetes.io/docs/reference/feature-gates/
    # params passed to the --feature-gates cli flag.
    feature_gates: ''
    #runtime configurations that may be passed to apiserver.
    # can be used to turn on/off specific api versions.
    # api/all is special key to control all api versions
    runtime_configs:
      - admissionregistration.k8s.io/v1alpha1
      - batch/v2alpha1
    admission_control:
      # - 'Initializers'
      - 'NamespaceLifecycle'
      - 'LimitRanger'
      - 'ServiceAccount'
      - 'NodeRestriction'
      - 'PersistentVolumeLabel'
      - 'DefaultStorageClass'
      - 'ResourceQuota'
      - 'DefaultTolerationSeconds'

# the cluster domain name used for internal infrastructure host <-> host  communication
internal_infra_domain: 'infra.devops.local'
ldap_internal_infra_domain: 'dc=infra,dc=devops,dc=local'
paths:
  service_account_key: '/etc/pki/sa.key'
  var_kubelet:    '/var/lib/kubelet'
  kubeconfig:     '/var/lib/kubernetes/kubeconfig'
  kube_scheduler_config: '/var/lib/kubernetes/kube-scheduler.kubeconfig'
  kube_controller_manager_config: '/var/lib/kubernetes/kube-controller-manager.kubeconfig'
  kubelet_config: '/var/lib/kubernetes/kubelet-config'
  kube_proxy_config: '/var/lib/kubernetes/kube-proxy-config'

# set log level for kubernetes services
# 0 - Generally useful for this to ALWAYS be visible to an operator.
# 1 - A reasonable default log level if you don't want verbosity.
# 2 - Useful steady state information about the service and important log
#     messages that may correlate to significant changes in the system.
#     This is the recommended default log level for most systems.
# 3 - Extended information about changes.
# 4 - Debug level verbosity.
# 6 - Display requested resources.
# 7 - Display HTTP request headers.
# 8 - Display HTTP request contents.
kube_log_level:   '2'

# CNI network configuration
cni:
  plugin: 'flannel'
  version: 'v0.11.0'
  hash_sha256: '136e859d5e5239d12effe312d599c3978f94d1b6ecff6bd18695cf022030f93a'
  local_install: True
  healthz_port: '10290'
cri:
  chosen: 'docker'
#private_regristry: '172.21.3.76:5000'