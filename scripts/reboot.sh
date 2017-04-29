#!/bin/bash
# WHAT: To install Virtualbox Guest Additions, we must have the latest kernel installed. To load the latest kernel, we have to reboot after yum installing it.
# REFERENCES: https://github.com/mitchellh/packer/issues/2580 http://www.packer.io/docs/provisioners/shell.html
set -x

reboot
sleep 60
