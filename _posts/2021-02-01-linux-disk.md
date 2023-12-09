---
title: Linux Disks
date: 2021-02-01 12:00:00
categories: [Linux]
tags: [linux, disk]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }

Automatically mount the disk to the file system:
```shell
cat <<EOF >> /etc/fstab
/dev/sdc1 /media/share auto nosuid,nodev,nofail 0 0
/dev/sdb2 /media/share auto nosuid,nodev,nofail 0 0
/dev/sdd1 /media/share auto nosuid,nodev,nofail 0 0
EOF
```

Mount efs on reboot
```shell
@reboot mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport efs-production.convectbeheervpc.nl:/ /efs
```

List Disks
```shell
lsblk
```

Get Disk UUID
```shell
blkid
```

Set permanent disk mount 
```shell
sudo nano /etc/fstab

UUID="6361-1CEF" /media/share/1T-001 ntfs nosuid,nodev,nofail 0 0
```

Disk Utility
```shell
sudo apt install smartmontools
```

Test disk
```shell
sudo smartctl -a /dev/sdX
```

Test disk speed
```shell
sudo dd if=/dev/sdX of=/tmp/test1.img bs=1G count=1 oflag=dsync
```
