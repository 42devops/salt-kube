# -*- mode: ruby -*-
# vi: set ft=ruby :

hosts = {
  "salt" => "172.16.10.10",
  "minion01" => "172.16.10.21",
  "minion02" => "172.16.10.22"
}
$script = <<SCRIPT

cat > /etc/hosts << EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
172.16.10.21 minion01
172.16.10.22 minion02
172.16.10.10 salt
EOF
swapoff -a
sed -i '/swap/d' /etc/fstab

if [  -n "$(uname -a | grep Ubuntu)" ]; then
  export DEBIAN_FRONTEND=noninteractive
  export DEBIAN_PRIORITY=critical
  sudo -E apt-get -qy update
  sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" upgrade
  sudo -E apt-get -qy autoclean
else
  yum update -y
fi

if [[ $(hostname -s) == 'salt' ]]; then
  mkdir -p /etc/salt
  echo -e 'roles:\n  - salt\n  - ca\n  - kube-master\n  - etcd\n' > /etc/salt/grains
  curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
  sh /tmp/install_salt.sh -M stable 2018.3.3
cat > /etc/salt/master << EOFM
auto_accept: True
peer:
  .*:
    - .*
peer_run:
  .*:
    - .*
file_roots:
  local:
    - /srv/salt/local
    - /srv/salt/local/roles
    - /srv/formulas
pillar_roots:
  local:
    - /srv/pillar/local
EOFM
  systemctl restart salt-master
else
  mkdir -p /etc/salt
  echo -e 'roles:\n  - kube-minion\n  - etcd\n' > /etc/salt/grains
  curl -L https://bootstrap.saltstack.com -o /tmp/install_salt.sh
  sh /tmp/install_salt.sh stable 2018.3.3
fi
cat > /etc/salt/minion << EOFS
master: salt
startup_states: highstate
multiprocessing: false
saltenv: local
EOFS
systemctl restart salt-minion

SCRIPT

Vagrant.configure("2") do |config|
  hosts.each do |name, ip|
    config.vm.define name do |machine|
      # machine.vm.box = "bento/ubuntu-18.04"
      machine.vm.box = "bento/centos-7.6"
      machine.vm.box_check_update = false
      machine.ssh.insert_key = false
      machine.vm.hostname = name
      machine.vm.network :private_network, ip: ip
      machine.vm.provision "shell", inline: $script
      machine.vm.synced_folder './dist', '/srv'
      machine.vm.provider "virtualbox" do |v|
          v.name = name
          if v.name == 'salt'
            v.customize ["modifyvm", :id, "--memory", 4048]
          else
            v.customize ["modifyvm", :id, "--memory", 2048]
          end
       end
    end
  end
end
