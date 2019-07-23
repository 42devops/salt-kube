#!/bin/bash

# Copyright 2015 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Download the etcd, flannel, and K8s binaries automatically and stored in binaries directory
# Run as root only

# author @resouer @WIZARD-CXY
set -e

function cleanup {
  # cleanup work
  rm -rf flannel* kubernetes* etcd* binaries
}
trap cleanup SIGHUP SIGINT SIGTERM

pushd $(dirname $0)
mkdir -p binaries

# docker
DOCKER_VERSION=${DOCKER_VERSION:-"18.06.3"}
DOCKER="docker-${DOCKER_VERSION}-ce"
echo "Prepare docker ${DOCKER_VERSION} release ..."
grep -q "^${DOCKER_VERSION}\$" binaries/.docker 2>/dev/null || {
  curl -L https://download.docker.com/linux/static/stable/x86_64/${DOCKER}.tgz -o binaries/${DOCKER}.tgz
  echo ${DOCKER_VERSION} > binaries/.docker
}

# flannel
FLANNEL_VERSION=${FLANNEL_VERSION:-"0.11.0"}
echo "Prepare flannel ${FLANNEL_VERSION} release ..."
grep -q "^${FLANNEL_VERSION}\$" binaries/.flannel 2>/dev/null || {
  curl -L  https://github.com/coreos/flannel/releases/download/v${FLANNEL_VERSION}/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz -o binaries/flannel-v${FLANNEL_VERSION}-linux-amd64.tar.gz
  echo ${FLANNEL_VERSION} > binaries/.flannel
}

# ectd
ETCD_VERSION=${ETCD_VERSION:-"3.3.12"}
ETCD="etcd-v${ETCD_VERSION}-linux-amd64"
echo "Prepare etcd ${ETCD_VERSION} release ..."
grep -q "^${ETCD_VERSION}\$" binaries/.etcd 2>/dev/null || {
  curl -L https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/${ETCD}.tar.gz -o binaries/${ETCD}.tar.gz
  echo ${ETCD_VERSION} > binaries/.etcd
}

# k8s
KUBE_VERSION=${KUBE_VERSION:-"1.14.3"}
echo "Prepare kubernetes ${KUBE_VERSION} release ..."
grep -q "^${KUBE_VERSION}\$" binaries/.kubernetes 2>/dev/null || {
 curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-apiserver" -o binaries/kube-apiserver
 curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-controller-manager" -o binaries/kube-controller-manager
 curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-scheduler" -o binaries/kube-scheduler
 curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubectl" -o binaries/kubectl
 curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kube-proxy" -o binaries/kube-proxy
 curl -L "https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/linux/amd64/kubelet" -o binaries/kubelet
 echo ${KUBE_VERSION} > binaries/.kubernetes
}

# vault
VAULT_VERSION=${VAULT_VERSION:-"1.1.3"}
VAULT="vault_${VAULT_VERSION}_linux_amd64"
echo "Prepare vault ${VAULT_VERSION} release ..."
grep -q "^${VAULT_VERSION}\$" binaries/.vault 2>/dev/null || {
  curl -L https://releases.hashicorp.com/vault/${VAULT_VERSION}/${VAULT}.zip -o binaries/${VAULT}.zip
  echo ${VAULT_VERSION} > binaries/.vault
}

# cni-plugins

CNI_PLUGINS_VERSION=${CNI_PLUGINS_VERSION:-"v0.8.1"}
CNI_PLUGINS="cni-plugins-linux-amd64-${CNI_PLUGINS_VERSION}"
echo "Prepare CNI_PLUGINS ${CNI_PLUGINS_VERSION} release ..."
grep -q "^${CNI_PLUGINS_VERSION}\$" binaries/.CNI_PLUGINS 2>/dev/null || {
  curl -L https://github.com/containernetworking/plugins/releases/download/${CNI_PLUGINS_VERSION}/${CNI_PLUGINS}.tgz -o binaries/${CNI_PLUGINS}.tgz
  echo ${CNI_PLUGINS_VERSION} > binaries/.cni-plugins
}



echo "Done! All your binaries locate in tests/binaries directory"
popd
