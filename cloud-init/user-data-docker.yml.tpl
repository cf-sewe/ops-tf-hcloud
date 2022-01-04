---
timezone: "Europe/Berlin"
users:
  - name: ansible
    lock_passwd: true
    ssh-authorized-keys:
      - "${ansible_public_key} Ansible"
    shell: "/bin/bash"
    sudo: ["ALL=(ALL) NOPASSWD:ALL"]
bootcmd:
  - [ sed, -i, '/10\.0\.2\.3/d', "/etc/resolv.conf" ]
runcmd:
  - [ chown, -R, "ansible:ansible", "/home/ansible" ]
