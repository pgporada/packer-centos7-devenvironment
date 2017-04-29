#!/bin/bash
yum -y erase gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts
yum -y clean all
rm -rf VBoxGuestAdditions_*.iso

# Clean up network interface persistence
rm -f /etc/udev/rules.d/70-persistent-net.rules;
rm -f /etc/sysconfig/network-scripts/ifcfg-eth1
ln -sf /dev/null /etc/udev/rules.d/70-persistent-net.rules

# Vagrant, as of 1.9.2, tries to interact with enp0s3 except that we want to use eth1
mv /etc/sysconfig/network-scripts/ifcfg-enp0s3 /etc/sysconfig/network-scripts/OFF_PACKER_ifcfg-enp0s3

for ndev in `ls -1 /etc/sysconfig/network-scripts/ifcfg-*`; do
    if [ "`basename $ndev`" != "ifcfg-lo" ]; then
        sed -i '/^HWADDR/d' "$ndev";
        sed -i '/^UUID/d' "$ndev";
    fi
done
