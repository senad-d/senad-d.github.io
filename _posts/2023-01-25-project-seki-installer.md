---
title: A quick and easy way to install a dev env for Docker.
date: 2023-01-25 12:00:00
categories: [Projects, SekiInstaller]
tags: [homelab, installer, dev]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/homelab-banner.jpeg?raw=true)

# Installer

Powerful bash script designed to streamline the process of installing essential software on a fresh Ubuntu installation for your Homelab environment. With a comprehensive set of features, SekiInstall empowers users to quickly and effortlessly set up their systems with the necessary tools and services.

## For Ubuntu 22.04 LTS (minimized install)

In this short video you can see the installation process of this script for "Basic install" and OpenVPN installation with SSL certificate, user and configuration download link.


<details><summary> Video </summary>

<div style="max-width: 100%; max-height: auto;">
  <video controls style="width: 100%; height: auto;">
    <source src="https://user-images.githubusercontent.com/96924112/181740725-fa98c0fc-8bf5-4bef-994c-c06c902b84a8.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</div>

</details>

---

```shell
git clone https://github.com/senad-d/SekiInstall.git install && cd install && sudo bash installer.sh
```

#### Install: 

| Program | Description |
| --- | --- |
| OpenVPN | Create a vpn server with vpn-user. |
| Samba | Enables Linux / Unix machines to communicate with Windows machines in a network. |
| Cockpit | Graphical interface to administer servers. |
| CrowdSec | Analyze behaviors, respond to attacks & share signals across the community. |
| Docker-compose | Tool that help define and share multi-container applications. |
| Docker | Enables you to separate your applications from your infrastructure. |
| Plex | Access all media. |
| Automate backup | Back up your files every day/weak/month automatically. |
| Lock SSH | Lock SSH session, accept only your KEY, forbid access from root. |
| Basic apps | Install Nano, Btop, Cron. |
| UFW | Enable and edit rules in UFW firewall. |
| Docker containers | Run docker multiple container's. |

#### Bootstrap scripts to choose from

<details><summary>Connecting to the server fom the domain name.</summary>
<p>

To be able to connect to yor home you need to do additional steps.
  - In the router you need to port forward ports 80, 443 and 22 (or use DMZ).
  - Buy domain name (I use namecheap.com).
  - Create account and connect your domain name to cloudflare.com for more security.
  - Configure NginxProxyMenager to point po the specific services and add a free SSL certificate.

</p>
</details>

<details><summary>SIMPLE Install</summary>
<p>

Create environment for docker containers.
  - Nano
  - Btop
  - Cron
  - Docker

</p>
</details>


<details><summary>BASIC Install</summary>
<p>

Create environment for docker containers with basic protection and monitoring.
  - Nano
  - Btop
  - Cron
  - Docker
  - Crowdsec
  - Cockpit
  - UFW

</p>
</details>


<details><summary>FULL Install</summary>
<p>

Create environment for docker containers with file sharing, media sharing, basic protection and monitoring.
  - Nano
  - Btop
  - Cron
  - Docker
  - Crowdsec
  - Cockpit
  - UFW
  - Samba
  - Plex

</p>
</details>

<details><summary>Run Docker-compose.yml</summary>
<p>

Run Docker images. (Start with Basic or Full install first.)
  - Portainer
  - Nginx
  - Homer
  - Grafana
  - Prometheus
  - Speedtest
  - Qbittorrent
  - Jackett
  - Radarr
  - Sonarr
  - Filebrowser
  - VSCode
  - Matomo
  - Wireguard
  - MariaDB
  - Node_exporter
  - Cadvisor
  - Cloudflare-ddns
  - Watchtower

</p>
</details>

<details><summary>Warning</summary>
<p>

⚠️ Please beware that products can change over time.

I do my best to keep up with the latest changes and releases, but please understand that this won’t always be the case.

</p>
</details>