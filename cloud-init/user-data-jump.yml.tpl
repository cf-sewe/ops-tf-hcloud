---
disable_root: false
ssh_pwauth: no
timezone: "Europe/Berlin"
manage_resolv_conf: true
resolv_conf:
  nameservers: ["1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001"]
  options:
    timeout: 1
users:
  - name: ansible
    ssh-authorized-keys:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4jw2Rt/3d0YuexTj0YEuV1VHcfK5XRH+HSHfw2JGCY sebastian.weitzel@collaboration-factory.de"
      - "${ansible_public_key}"
    shell: "/bin/bash"
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: sudo
package_update: true
package_upgrade: true
package_reboot_if_required: true
packages:
  - centos-release-ansible-29
  - ansible
runcmd:
  - updatedb
