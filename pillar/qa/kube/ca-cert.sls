certificate_information:
  subject_properties:
    C: CN
    Email:
    GN:
    L: Beijing
    O: system:nodes
    OU: Devops Team
    SN:
    ST: Beijing
  days_valid:
    ca_certificate: 3650
    certificate: 365
  days_remaining:
    ca_certificate: 90
    certificate: 90

ssl:
  ca_dir: '/etc/pki/trust/anchors'
  ca_file: '/etc/pki/trust/anchors/DevOps_CA.crt'
  crt_file: '/etc/pki/minion.crt'
  key_file: '/etc/pki/minion.key'

  crt_dir: '/etc/pki'
  key_dir: '/etc/pki'

  kubectl_key: '/etc/pki/kubectl-client-cert.key'
  kubectl_crt: '/etc/pki/kubectl-client-cert.crt'

  kube_apiserver_key: '/etc/pki/kube-apiserver.key'
  kube_apiserver_crt: '/etc/pki/kube-apiserver.crt'

  kube_apiserver_proxy_key: '/etc/pki/private/kube-apiserver-proxy.key'
  kube_apiserver_proxy_crt: '/etc/pki/kube-apiserver-proxy.crt'
  kube_apiserver_proxy_bundle: '/etc/pki/private/kube-apiserver-proxy-bundle.pem'

  kube_scheduler_key: '/etc/pki/kube-scheduler.key'
  kube_scheduler_crt: '/etc/pki/kube-scheduler.crt'

  kube_controller_manager_key: '/etc/pki/kube-controller-manager.key'
  kube_controller_manager_crt: '/etc/pki/kube-controller-manager.crt'

  kubelet_key: '/etc/pki/kubelet.key'
  kubelet_crt: '/etc/pki/kubelet.crt'

  kube_proxy_key: '/etc/pki/kube-proxy.key'
  kube_proxy_crt: '/etc/pki/kube-proxy.crt'

