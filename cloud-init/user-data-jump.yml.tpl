---
timezone: "Europe/Berlin"
users:
  - name: ansible
    ssh-authorized-keys:
      - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4jw2Rt/3d0YuexTj0YEuV1VHcfK5XRH+HSHfw2JGCY sebastian.weitzel@collaboration-factory.de"
      - "${ansible_public_key} Ansible"
    shell: "/bin/bash"
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
    groups: sudo
runcmd:
  - updatedb
  - sed '/10\.\0\.2\.3/d' /etc/resolv.conf
