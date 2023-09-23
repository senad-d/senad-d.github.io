---
title: GPU pasture to VM
date: 2021-02-01 12:00:00
categories: [OS, Linux]
tags: [linux, vm, gpu]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }

## Enable IOMMU
nano /etc/default/grub
```shell
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"
```
update-grub

## Enable VFIO
nano /etc/modules
```shell
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

## Install VM
```shell
sudo apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager spice-vdagent
sudo usermod -aG libvirt shiba
sudo usermod -aG kvm shiba

```

## Prepare Windows.iso and Virtio Drivers
```shell
wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

wget "https://software.download.prss.microsoft.com/dbazure/Win10_22H2_English_x64.iso?t=0ce3bc8e-efb0-454f-bf4d-e1afa7c73ef0&e=1672486634&h=e552cb4c6b8124c7d0fcbb83f07b3c98ae7d4c39d10c0e76f137ba9c29794881"
mv 'Win10_22H2_English_x64.iso?t=0ce3bc8e-efb0-454f-bf4d-e1afa7c73ef0&e=1672486634&h=e552cb4c6b8124c7d0fcbb83f07b3c98ae7d4c39d10c0e76f137ba9c29794881' Win10_22H2_English_x64.iso
```

## Install Nvidia drivers
```shell
sudo apt install -y build-essential linux-headers-$(uname -r)
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo apt update
sudo apt search nvidia-driver
sudo apt install nvidia-driver-525 nvidia-dkms-525 -y
sudo reboot now
```

## Patch Nvidia drivers for encoding
```shell
git clone https://github.com/keylase/nvidia-patch.git && cd nvidia-patch
sudo bash patch.sh
```

## Single GPU passthrough
```shell
git clone https://gitlab.com/risingprismtv/single-gpu-passthrough.git && cd single-gpu-passthrough
chmod -x install_hooks.sh
cd hooks
chmod -x qemu
chmod -x vfio-startup.sh
chmod -x vfio-teardown.sh
cd ..
sudo su
sudo bash install_hooks.sh
```

## Docker GPU passthrough
```shell
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt update
sudo apt install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi
```

## Run Virt-Manager from ssh
```shell
ssh -X user@1.1.1.1
virt-manager
```
