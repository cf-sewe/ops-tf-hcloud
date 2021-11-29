#!/bin/bash

set -e

echo "Installing Ansible"
dnf -qy install git-core centos-release-ansible-29
dnf -qy install ansible

echo "TODO Configuring Ansible"
# checkout ansible code
# setup cron job
echo "Done."
