---
title: Networking
date: 2021-04-01 12:00:00
categories: [OS, Linux]
tags: [linux, ip]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true)

## Change Hostname
```bash
hostnamectl set-hostname newhostname
```

## Change IP Address in Ubuntu 20.04 LTS

1. Create a new file `/etc/netplan/01-netcfg.yaml`
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens3:
      dhcp4: no
      addresses:
        - 192.168.121.221/24
      gateway4: 192.168.121.1
      nameservers:
          addresses: [8.8.8.8, 1.1.1.1]
```

2. Apply changes
```bash
netplay apply
```

## Change IP Address in Ubuntu 22.04 LTS
gateway4 has been depricated in ubuntu 22.04 release and routes is used instead!

1. Create a new file `/etc/netplan/00-installer-config.yaml`
```yaml
network:
  ethernets:
    enp5s0:
      dhcp4: false
      addresses: [192.168.1.37/24]
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8,192.168.1.1]
  version: 2
```
1.1 Create  `/etc/netplan/00-installer-config-wifi.yaml`
```yaml
network:
  version: 2
  wifis:
    wlp9s0:
      access-points:
        SSID:
          password: 'PASS'
      dhcp4: true
```
2. Apply changes
```bash
netplay apply
```

Get hardware info
```bash
sudo lshw -short
```

## Check open ports and apps useing them
```bash
sudo ss -tulwnp | grep LISTEN
```