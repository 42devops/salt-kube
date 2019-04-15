#!/bin/bash
SALT-MATSTER=$1
ROLES=$2
if [ -z `which salt-minion` ]
then
    curl -o install_salt.sh -L https://bootstrap.saltstack.com
    sudo sh install_salt.sh -P
fi
sudo echo "${SLAT-MASTER} salt" >> /etc/hosts
sudo salt-call --local grains.set roles "${ROLES}"
sudo salt-call --local service.restart salt-minion
sudo salt-call state.apply