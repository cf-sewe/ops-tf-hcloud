# Operations Terraform: Hetzner Cloud

## Description

Terraform is used to manage the infrastructure aspects of our operational stack hosted in the Hetzner Cloud (hcloud).
Currently, we use the hcloud for shared infrastructure. It can also be used for internal or non-critical production cplace instances.
Critical production cplace instances are still hosted on dedicated Hetzner root servers, which are bootstrapped manually and then provisioned via Ansible.

The following shared components are deployed in the hcloud:

- SSH Jump Host
- Automation Host (Ansible)

Furthermore Terraform is used to manage a Ansible staging environment.

For Ansible changes, GitHub actions are used to perform:

- Syntax check / LINT (on each PR commit)
- Run Ansible integration testing (manually triggered)
  - Using Terraform, start a fresh Hetzner Cloud environment
  - Run Ansible and check it completed successfully
  - Run basic integration tests (cplace is available, ...)

## Terraform Tasks

- provision cloud instance
- prepare basic Linux system (cloud init)
- Preparations for Ansible
  - role: Ansible server (automation users, run Ansible, private key)
  - role: Ansible target (mainly get automation user + key)

## Environments

Each customer gets their own environment:

- Own jump server / automation server
- Own 
