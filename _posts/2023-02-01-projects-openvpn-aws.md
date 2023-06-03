---
title: OpenVPN for AWS
date: 2023-02-01 12:00:00
categories: [Projects, OpenVPN, AWS]
tags: [aws, openvpn]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true)

A CloudFormation template for adding an EC2 instance with a fully automated bootstrap script to create a VPN that automatically creates SSL certificates and allows easy management of users.

![](https://private-user-images.githubusercontent.com/114985182/205624165-ba77b327-11bd-40ed-a912-92f6dcecf084.mp4?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJrZXkiOiJrZXkxIiwiZXhwIjoxNjg1ODE3MTg5LCJuYmYiOjE2ODU4MTY4ODksInBhdGgiOiIvMTE0OTg1MTgyLzIwNTYyNDE2NS1iYTc3YjMyNy0xMWJkLTQwZWQtYTkxMi05MmY2ZGNlY2YwODQubXA0P1gtQW16LUFsZ29yaXRobT1BV1M0LUhNQUMtU0hBMjU2JlgtQW16LUNyZWRlbnRpYWw9QUtJQUlXTkpZQVg0Q1NWRUg1M0ElMkYyMDIzMDYwMyUyRnVzLWVhc3QtMSUyRnMzJTJGYXdzNF9yZXF1ZXN0JlgtQW16LURhdGU9MjAyMzA2MDNUMTgyODA5WiZYLUFtei1FeHBpcmVzPTMwMCZYLUFtei1TaWduYXR1cmU9YTQ1YmU1MTgyZTcyZTY3N2MzNjIyOWNjM2MwODgxYjUyZmQ1YTYwNGI1OTc2ODFmMGE0NjYzYmY0YzI4ZTI4MiZYLUFtei1TaWduZWRIZWFkZXJzPWhvc3QifQ.RtRj1yYXrZP7wWHuLS9Yfq6C9cHl30_NzcaDUTPNlBQ)


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
-   VPN bootstrap script for installing and running OpenVPN 

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/20221120184106.png?raw=true)

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

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/vpn_user.png?raw=true)

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/file_io.png?raw=true)