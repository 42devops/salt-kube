SHELL := /bin/bash
GIT_SHA = $(shell git log --pretty=oneline | head -n1 | cut -c1-8)
PACKAGE = "salt_config-$(GIT_SHA).tgz"
SHASUM = $(shell test `uname` == 'Darwin' && echo shasum -a 256 || echo sha256sum)
env := "local"
KUBE_VERSION := "1.14.1"
DOCKER_VERSION := "18.06.3"
FLANNEL_VERSION := "0.11.0"
ETCD_VERSION := "3.3.12"
VAULT_VERSION := "1.1.1"


all: formulas
	@mkdir -p dist
	@rsync -a ./salt/$(env) ./dist/salt/ --delete
	@rsync -a ./_grains/ ./dist/salt/$(env)/_grains/ --delete
	@rsync -a ./_macros/ ./dist/salt/$(env)/_macros/ --delete
	@rsync -a ./_states/ ./dist/salt/$(env)/_states/ --delete
	@rsync -a ./_modules/ ./dist/salt/$(env)/_modules/ --delete
	@rsync -a ./_runners/ ./dist/_runners/ --delete
	@rsync -a ./reactor/ ./dist/reactor/ --delete
	@rsync -a ./formulas/ ./dist/formulas/ --delete
	@rsync -a ./pillar/$(env) ./dist/pillar/ --delete
	@echo "copy local install file to ./dist. Enjoy!"
	@rsync -a tests/binaries/kube-apiserver dist/formulas/kube-apiserver/files
	@rsync -a tests/binaries/kube-controller-manager dist/formulas/kube-controller-manager/files
	@rsync -a tests/binaries/kube-scheduler dist/formulas/kube-scheduler/files
	@rsync -a tests/binaries/kubectl dist/formulas/kubectl/files
	@rsync -a tests/binaries/kube-proxy dist/formulas/kube-proxy/files
	@rsync -a tests/binaries/kubelet dist/formulas/kubelet/files
	@rsync -a tests/binaries/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz dist/formulas/etcd/files
	@rsync -a tests/binaries/docker-$(DOCKER_VERSION)-ce.tgz dist/formulas/docker/files
	@rsync -a tests/binaries/flannel-v$(FLANNEL_VERSION)-linux-amd64.tar.gz dist/formulas/kube-cni/flannel/files
	@rsync -a tests/binaries/vault_$(VAULT_VERSION)_linux_amd64.zip dist/formulas/vault/files
	@echo $(GIT_SHA) > ./dist/SHA
	@find ./dist -type f | sort | xargs $(SHASUM) | sed "s;./dist;/srv;" > MANIFEST
	@$(SHASUM) MANIFEST | cut -d\  -f1 > MANIFEST.sha256
	@mv MANIFEST* ./dist/
	@echo "Salt $(env) env is ready in ./dist. Enjoy!"

localinstall:
	@cp -f tests/binaries/kube-apiserver dist/formulas/kube-apiserver/files
	@cp -f tests/binaries/kube-controller-manager dist/formulas/kube-controller-manager/files
	@cp -f tests/binaries/kube-scheduler dist/formulas/kube-scheduler/files
	@cp -f tests/binaries/kubectl dist/formulas/kubectl/files
	@cp -f tests/binaries/kube-proxy dist/formulas/kube-proxy/files
	@cp -f tests/binaries/kubelet dist/formulas/kubelet/files
	@cp -f tests/binaries/etcd-v$(ETCD_VERSION)-linux-amd64.tar.gz dist/formulas/etcd/files
	@cp -f tests/binaries/vault_$(VAULT_VERSION)_linux_amd64.zip dist/formulas/vault/files
	@cp -f tests/binaries/flannel-v$(FLANNEL_VERSION)-linux-amd64.tar.gz dist/formulas/kube-cni/flannel/files
lint:
	@tests/lint.sh

test: clean all lint
	@true

package: clean all
	@tar czf $(PACKAGE) ./dist/
	@mv -f $(PACKAGE) ./dist
	@echo "Package ./dist/$(PACKAGE) is ready."

clean:
	@echo -n "Removing vagrant VMs..."
	@vagrant destroy -f
	@echo "DONE"
	@echo -n "Removing ./dist directory..."
	@rm -rf dist
	@echo "DONE"

coverage:
	@tests/coverage.sh

download:
	@echo -n 'Download the binaries package to ./tests/binaries directory...'
	@tests/download.sh

init: all
	vagrant up
	vagrant ssh salt -c "sudo salt salt state.sls salt.master"
	sleep 20
	vagrant ssh salt -c "sudo salt \* state.sls salt.minion"
	sleep 20
	vagrant ssh salt -c "sudo salt salt state.sls caserver.initca"
	sleep 10
	vagrant ssh salt -c "sudo salt salt state.sls caserver"
	sleep 10
	vagrant ssh salt -c "sudo salt \* mine.update"
	sleep 10
	vagrant ssh salt -c "sudo salt \* state.apply -l debug"
	sleep 20
	vagrant ssh salt -c "sudo salt \* state.apply -l debug"