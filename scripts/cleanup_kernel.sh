#!/bin/bash
# AUTHOR: Phil Porada - philporada@gmail.com
# WHAT: Remove the original Cent7 kernel after the elrepo kernel upgrade reboot.
set -o pipefail
set -x

yum remove -y kernel-3*
