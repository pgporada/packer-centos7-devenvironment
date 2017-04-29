#!/bin/bash
# Author: Phil Porada - philporada@gmail.com
# WHAT: Run serverspec tests that Packer copies up to the server during the build phase
# NOTES: Bundler is installed a different script

cd /tmp/tests
/usr/local/bin/bundler install
/usr/local/bin/rake spec
cd /tmp
rm -rf /tmp/tests
