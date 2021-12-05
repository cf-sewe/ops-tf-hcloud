# Operations Terraform: Hetzner Cloud

## Description

Terraform is used to manage the infrastructure aspects of our operational stack hosted in the Hetzner Cloud (hcloud).

The following shared components are deployed in the hcloud:

- SSH Jump Host combined with Ansible server
- Reverse Proxy or Loadbalancer
- Forward Proxy
- Database server
- Elasticsearch server

Additionally, there can be deployed one or more cplace instances (single or multi-node).


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

Note: The SSH key for Ansible is created by Terraform.
There is no need to store it in GIT.

## Environments

Each customer gets their own environment, with following components:

| Component | Private IP | Description |
|---|---|---|
| Jump Server | 10.77.1.2 | Jump and automation server |
| Forward Proxy | 10.77.1.3 | Handle internet facing traffic (Squid) |
| cplace node 1 | 10.77.1.10 | Site 1 / Node 1  |
| cplace node 2 | 10.77.1.11 | Site 1 / Node 2 |
| cplace node 1 | 10.77.1.20 | Site 2 / Node 1 |
| cplace node 2 | 10.77.1.21 | Site 2 / Node 1 |

## Design Ideas

- only jump server is reachable for SSH access from internet zone.
- application server cannot reach internet directly, uses forward proxy
- A bootstrap SSH key will be created by Terraform.
  It can be used to login as root to the server in case any issues in the bootstrapping phase occur.
  After Ansible Hardening completed, SSH root login will no longer be possible.

### Jump Server

The jump server (also known as bastion host) is the only server reachable from the internet directly

### Separation vs. All on One

Dedicated Hetzner servers are powerful and cost-efficient machines.
They offer a lot of CPU, Memory and fast storage space.
Therefore in that scenario it made sense to deploy all cplace components on one server.

With a virtualized environment however, and broad range of offerings of configurations this changes.
In the Hetzner Cloud you can select servers between 1 to 32 vCPUs, 2 to 128GB RAM and up to 1 TB Storage.
Also, there is an API available to support provisioning of the environment by automation.

In the hcloud it makes sense to isolate cplace dependencies to their own virtual server.
This however impacts the backup concept, it becomes harder to do a recovery.
In order to address this properly, recovery needs to be automated.
It also means transport encryption between the components (e.g. cplace to DB) is mandatory.

To support active-passive concept, it means we need to synchronize all components to the other site.
It also probably means we are restricted to the ZFS filesystem, to support the efficient replication.


