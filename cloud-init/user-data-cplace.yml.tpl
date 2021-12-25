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
resize_rootfs: false
growpart:
  mode: off
bootcmd:
  - [ sed, -i, '/10\.0\.2\.3/d', "/etc/resolv.conf" ]
# https://gist.github.com/ctron/88fa70926fc14c894e42ecf373cb271e
runcmd:
  - [ chown, -R, "ansible:ansible", "/home/ansible" ]
  - [ sgdisk, -e, "/dev/sda" ]
  - [ parted, -s, "/dev/sda", mkpart, data, ext4, "20GB", "100%" ]
  - [ partprobe ]
  - [ growpart, "/dev/sda", "1" ]
  - [ partx, --update, "/dev/sda" ]
  - [ resize2fs, /dev/sda1 ]

