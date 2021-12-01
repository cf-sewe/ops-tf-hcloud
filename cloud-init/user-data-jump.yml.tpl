---
timezone: "Europe/Berlin"
users:
  - name: ansible
    lock_passwd: true
    ssh-authorized-keys:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4jw2Rt/3d0YuexTj0YEuV1VHcfK5XRH+HSHfw2JGCY sebastian.weitzel@collaboration-factory.de"
      - "${ansible_public_key} Ansible"
    shell: "/bin/bash"
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
write_files:
  - encoding: base64
    content: "${ansible_private_key}"
    path: /home/ansible/.ssh/id_rsa
    permissions: '0400'
packages:
  - git-core
  - centos-release-ansible-29
bootcmd:
  - [ sed, -i, '/10\.0\.2\.3/d', "/etc/resolv.conf" ]
runcmd:
  - [ chown, -R, "ansible:ansible", "/home/ansible" ]
