#!/bin/bash
date > /etc/vagrant_box_build_time

# Installing vagrant keys
mkdir -p /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# MOTD
echo -e "
   ___  ___ _  _ ____ _   _ ___ ____ ____  _  _
  / _ \/ __/ |/ / ___/ / / /  _/ ___/ __ \/ |/ /
 / ___/ _//    / (_ / /_/ // // /__/ /_/ /    /
/_/  /___/_/|_/\___/\____/___/\___/\____/_/|_/

Penguicon Dev Environment
Built: $(date)
" > /etc/motd
