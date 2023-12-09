---
title: OpenVPN for Azure
date: 2023-02-02 12:00:00
categories: [Projects]
tags: [azure, openvpn]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/azure-banner.png?raw=true){: .shadow }

ARM template for adding VM with a fully automated bootstrap script to create a VPN that automatically creates SSL certificates and allows easy management of users.

<details><summary> Video </summary>

<div style="max-width: 100%; max-height: auto;">
  <video controls style="width: 100%; height: auto;">
    <source src="https://github.com/senad-d/senad-d.github.io/raw/main/_media/video/azure_arm_vpn.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</div>

</details>


### Creation Process:
1. Create a Resource groups
2. Run [Azure OpenVPN ARM template](https://senad-d.github.io/posts/projects-openvpn-azure-arm/) 
3. Edit VM Networking to create a user
		- Add inbound security rule for SSH port 22

### Resources creation for VPN:
- Resource group
- Virtual network
- Network Interface
- Network security group
- Virtual machine
- Public IP address
- Disk

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/20221121004547.png?raw=true){: .shadow }

#### Running ARM temp from Azure CLI

1. Log in to Azure

   ```shell
   az login
   ```

2. Set the right subscription

   ```shell
   az account set --subscription "your subscription id"
   ```

3. Create the Resource group

   ```shell
   az account list-locations
   az group create --name "resource-group" --location "your location"
   ```

4. Deploy the ARM template

   ```shell
   az group deployment create --name "name of your deployment" --resource-group "resource-group" --template-file "./azuredeploy.json"
   ```

5. In Azure CLI fill in "Linux OS Password" parameter

-   At least 12 characters
-   A mixture of both uppercase and lowercase letters
-   A mixture of letters and numbers
6. Open SSH port for managing users
- Visit VM Network 
- Enable SSH connection for the VM and after the managment is over disable it.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/add_ssh_rule.png?raw=true){: .shadow }

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/inbound_security_rule_azure.png?raw=true){: .shadow }

7. Create or remove a VPN user
Connect with SSH to the VM and use scripts to manage users.
go to the /root folder and use:
- Create user:
```shell
./create_vpn_user firstname-lastname
```
- Remove user:
```shell
./revoke_vpn_user firstname-lastname
```
- Fix network issues:
```shell
./repair-net
```
- Check who is connected to the VPN
```shell
cat /var/log/openvpn/openvpn-status.log | sed '/ROUTING/q' | head -n -1
```
***After the user is created send the one-time link to the user***

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/vpn_user.png?raw=true){: .shadow }

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/file_io.png?raw=true){: .shadow }
