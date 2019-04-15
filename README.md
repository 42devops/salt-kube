## salt-kube Project

- install `git` and `vagrant`.
- clone repo and download binaries package
- build for env

### download binaries package

setting version on `tests/download.sh` if you want

```
make download
```

### startup local env using vagrant

```
make init
```

### login local env to test

```
vagrant ssh salt
sudo su -
kubectl get no
```

### other notes

init cluster manual by command

```bash
vagrant up
vagrant ssh salt
salt \* test.ping
# sync all modules for salt
salt-run saltutil.sync_all saltenv=local
# setting roles for def whith salt/<env>/roles.yaml
salt-run state.orchestrate orch.setting_roles saltenv=local
# run orchstate for kubernetes install
salt-run state.orchestrate orch.kubernetes saltenv=local
```

> pls notes setting local vm networks interfaces into Pillar files

## TODO

- [ ] Add good README page
- [ ] CoreDNS addons setup
- [ ] Ingress addons setup
- [ ] Containerd support
- [ ] Calico network suport
- [ ] Monitor support(prometheus stack)
- [ ] Logging support(fluentbit stack)
- [ ] [istio](https://istio.io/) support
- [ ] [dex](https://github.com/dexidp/dex) support
- [ ] cert renew auto as `salt-run` task
- [ ] find a way to Testing
- [ ] all local install from yum repo OR nexus repo
- [ ] ...

## Reference

- https://github.com/BadgerOps/salt-workspace
- https://github.com/mitodl/salt-ops
- https://github.com/kubic-project/salt
