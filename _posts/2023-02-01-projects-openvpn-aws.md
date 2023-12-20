---
title: OpenVPN for AWS
date: 2023-02-01 12:00:00
categories: [Projects, OpenVPN]
tags: [aws, openvpn]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

A CloudFormation template for adding an EC2 instance with a fully automated bootstrap script to create a VPN that automatically creates SSL certificates and allows easy management of users.

<details><summary> Video </summary>

<div style="max-width: 100%; max-height: auto;">
  <video controls style="width: 100%; height: auto;">
    <source src="https://github.com/senad-d/senad-d.github.io/raw/main/_media/video/openvpn_aws.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
</div>

</details>


##### Resources used:
-   OpenVPN CloudFormation
	1.  Ec2 instance creation
	2.  Vpc Selection
	3.  Subnet selection
	4.  Security group creation
	5. EIP creation
	6. ENI creation
	7. Role creation
	8. Policy creation
	9. FlowLog creation
	10. S3 Bucket
	11. SES
-   VPN bootstrap script for installing and running OpenVPN 

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/oepnvpn-aws-cf.png?raw=true){: .shadow }

### 1. CloudFormation template

Created [***OpenVPN CloudFormation***](https://senad-d.github.io/posts/projects-openvpn-aws-cf/) for creating resources in AWS needed to run the VPN server.

### 2. Bootstrap script for installing OpenVPN

Created AWS_OpenVPN_bootstrap_script that runs all commands that are necessary for the setup:
	- Import OpenVPN GPG key
	- Create the repository file
	- Update apt and install OpenVPN
	- Download & extract EasyRSA
	- Configure your EasyRSA environment variables file
	- Initialize the PKI Structure for EasyRSA
	- Create the CA Certificate
	- Create your OpenVPN Server Configuration
	- Create the client-base configuration
	- The Certificate Creation Script
	- Certificate Revocation Script
	- Configure the Network Stack
	- Start OpenVPN
	- Add additional security for SSH

### 3. Created GitHub private repository and access token with only permission to clone that repository.

Placed files in this repository to be used in a [***bootstrap script***](https://senad-d.github.io/posts/projects-openvpn-aws-boot/) with the access token in order to safely use CloudFormation parameters in UserData.

```shell
git clone https://<access token>@github.com/user/repo.git /root/OpenVPN
# Copy bash.sh into a CloudFormation template UserData script in order to be able to get variables from parameters.
cat /root/OpenVPN/AWS/bash.sh >> /root/start_OpenVPN.sh
rm -rf /root/OpenVPN
```

### 4. Create a Grafana dashboard for tracking logs
If possible load the [[CloudWatch_Logs]] dashboard into Grafana for easy log viewing. 

### 5. Create a VPN user
Connect to the ec2 instance and use scripts to manage users.
go into the /root folder
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

## Create OpenVPN users through a list

To streamline and simplify the process of creating a larger number of users requiring access, you can utilize a [***GitHub Action***](https://senad-d.github.io/posts/projects-openvpn-github-action/). One prerequisite for its usage is that during the deployment of the CloudFormation template, you have provided a verified email address for SES.

Here's a step-by-step guide:

1. Create a new private repository and add secrets for actions to establish a connection with AWS.
2. Create an action to synchronize the user list with OpenVPN.
3. Generate a new user list in the email address format, with each user listed on a separate line. Save the file as:
	./users/vpn_user_list
	```shell
	mail1@example.com
	mail2@example.com
	mail3@example.com
	```
4. Once the changes are pushed to GitHub, your OpenVPN will create new users and send them an email containing the configuration file. Please note that the configuration file will expire within 24 hours of receiving the email.

By following these steps, you can efficiently generate OpenVPN users and automate the process using GitHub Actions.