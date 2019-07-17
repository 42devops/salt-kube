## salt-kube Project

## 1. Package version

- CentOS 7.6+
- **Ubuntu 18.04** (default)
- Saltstack 2018.3.3
- Etcd v3.3.12
- Docker v18.0.6-ce
- Flannel v0.11.0
- Kubernetes v1.14.3
- Vault v1.1.1
- CoreDNS v1.5.0
- **Cilium v1.5.5** (default) (only on `Ubuntu`)
- Istio 1.1.7

## 2. How to quickstart on local

- install `git` and `vagrant`.
- clone repo and download binaries package
- build for env

### Download binaries package

setting version on `tests/download.sh` if you want, and update `Makefile` for version

```bash
make download
```

### Startup local env using vagrant

if got some error, re-run `make init`

```bash
make init
make init
```

### Login local env to test

```bash
vagrant ssh salt
sudo su -
kubectl get no
```

### Other notes

1. change `Ubuntu` Or `CentOS` at local env, edit `Vagrantfile`

```
Vagrant.configure("2") do |config|
  hosts.each do |name, ip|
    config.vm.define name do |machine|
      machine.vm.box = "bento/ubuntu-18.04"
      # machine.vm.box = "bento/centos-7.6"
```

2. init cluster manual by command

```bash
vagrant up
vagrant ssh salt
# testing salt minions
salt \* test.ping
# sync all modules for salt
salt-run saltutil.sync_all saltenv=local
# setting roles for def whith salt/<env>/roles.yaml
salt-run state.orchestrate orch.setting_roles saltenv=local
# run orchstate for kubernetes install
salt-run state.orchestrate orch.kubernetes saltenv=local
```

> pls notes setting local vm networks interfaces into Pillar files `pillar/local/common/init.sls`

3. if you want add requirements packages

add it into this files:

- `pillar/local/common/packages_centos.sls`
- `pillar/local/common/packages_ubuntu.sls`

## 3. TODO

- [x] Add `Ubuntu` support
- [x] move all OS requirements packages into `package` formulas
- [x] [Cilium](https://cilium.io/) network suport
- [ ] Add good README page
- [x] CoreDNS addons setup
- [ ] Ingress addons setup
- [ ] Containerd support
- [ ] Monitor support(prometheus stack)
- [ ] Logging support(fluentbit stack)
- [x] [istio](https://istio.io/) support
- [ ] [dex](https://github.com/dexidp/dex) support
- [ ] cert renew auto
- [ ] find a way to Testing
- [ ] ...

## 4. Reference

- https://github.com/BadgerOps/salt-workspace
- https://github.com/mitodl/salt-ops
- https://github.com/kubic-project/salt
