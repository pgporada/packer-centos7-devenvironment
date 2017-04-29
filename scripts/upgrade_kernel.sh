#!/bin/bash
set -o pipefail
set -x

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
yum install -y http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
yum-config-manager --enable elrepo-kernel

yum remove -y kernel-{devel,tools,tools-libs,headers}

yum install -y kernel-lt{,-devel,-tools,-tools-libs,-headers}

yum install -y dkms gcc redhat-lsb-languages python-perf

grub2-mkconfig -o /boot/grub2/grub.cfg
chmod 0600 /boot/grub2/grub.cfg
grep vmlinuz /boot/grub2/grub.cfg
grub2-set-default 0
