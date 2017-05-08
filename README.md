# Overview

This project does the following
* Builds a CentOS 7 VM
* Installs a specific set of packages per the provisioning scripts
* Runs ServerSpec tests as an example showing that you can run tests prior to publishing a base image

- - - -

# Usage

Use remote Atlas to build a version of the vagrant. (Use this if you have an Atlas account)

    vagrant login
    make build-remote

Build a new version of the vagrant on your local machine (Preferred if you don't have an Atlas account)

    make build-local

Add a local build into vagrant as a vm named `test`

    vagrant box add packer_whatever_output --name test

- - - -
# Theme Music
[The Slackers - Same Everyday](https://www.youtube.com/watch?v=Qy_2OqTvW34)

- - - -
# Author and License

GPLv3

(c) 2016 Phil Porada
