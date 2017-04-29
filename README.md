# Overview

This project builds the VM that runs the `ansible-playbook-glapp` vagrant and `docker-microservice-devenv`.

- - - -

# Usage

Sign into Atlas

    vagrant login

Use Atlas to build a version of the vagrant. (Use this)

    make build-remote

Build a new version of the vagrant on your local machine and send it up to Atlas.

    make build-local

Add a local build into vagrant as a vm named `test`

    vagrant box add packer_whatever_output --name test
