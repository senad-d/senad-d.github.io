---
title: OpenVPN CloudFormation
date: 2023-02-01 12:00:00
categories: [Projects, OpenVPN, AWS, CloudFormation]
tags: [aws, openvpn, cloudformation]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true)

CloudFormation template for creating an automated VPN solution for AWS.
This template will create an EC2 instance with the bootstrap script for installing OpenVPN, which can be placed in a VPC of your choice to create a secure way of connecting to the infrastructure.

```shell
---
AWSTemplateFormatVersion : 2010-09-09
Description : Add OpenVPN EC2 to VPC
# Specifie parameters for the stack.
Parameters:
  ProjectName:
    Description: This will be used for for resource names, keyname and tagging. Resource name can include letters (A-Z and a-z), and dashes (-).
    Type: String
    MinLength: "3"
    Default: vpn
  AdminFullName:
    Description: Enter Administrator first and last name with "-" in the middle, no spaces.
    Type: String
    Default: firstname-lastname
  Email:
    Description: Enter admin email address
    Type: String
    Default: example@email.com
  Organisation:
    Description: Enter Organisation unet name
    Type: String
    Default: DevOps-team
  Company:
    Description: Enter Company name
    Type: String
    Default: Typeqast
  VpcID:
    Description: Which VPC would you like to use for Ec2 instance?
    Type: AWS::EC2::VPC::Id
    ConstraintDescription : VPC must exist
  PublicSubnet:
    Description: Which Pulic Subnet would you like to use for the Ec2 instance?
    Type: AWS::EC2::Subnet::Id
    ConstraintDescription : Subnet must exist
  InstanceType:
    Type: String
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Default: t2.micro
    Description : Select Instance Type.
  AmiId:
    Description: Region specific AMI from the Parameter Store
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id
    ConstraintDescription: Please enter Ubuntu AMI link
  OpenVPNKeyPair:
    Description: Which SSH Key would you like to use for remote access to Ec2 instance?
    Type: AWS::EC2::KeyPair::KeyName
    ConstraintDescription : Key Pair must exist
  SSHSourceCidr:
    Description: Enter IPv4 address allowed to access your OpenVPN Host via SSH?
    Type: String
    Default: 0.0.0.0/0
    AllowedPattern: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?$"
    ConstraintDescription: The value must be valid IPv4 CIDR block.
# Provide additional information about the template.
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      - Label:
          default: "Connect to AWS resources with OpenVPN"
        Parameters:
          - ProjectName
          - AdminFullName
          - Email
          - Organisation
          - Company
          - VpcID
          - PublicSubnet
          - InstanceType
          - AmiId
          - OpenVPNKeyPair
          - SSHSourceCidr
    ParameterLabels:
      ProjectName:
        default: "Resources names"
      AdminFullName:
        default: "Admin name"
      Email:
        default: "Admin email"
      Organisation:
        default: "Organisation unit name"
      Company:
        default: "Company name"
      VpcID:
        default: "Select VPC"
      PublicSubnet:
        default: "Select Subnet"
      InstanceType:
        default: "Select instance type"
      AmiId:
        default: "Select instance AMI"
      OpenVPNKeyPair:
        default: "Allowed SSH KEY"
      SSHSourceCidr:
        default: "Allowed IP addresses"
# Specifie the stack resources and their properties.
Resources:
  # Creat EC2 Instance for the OpenVPN.
  OpenVPN:
    Type: AWS::EC2::Instance
    Properties:
      KeyName: !Ref OpenVPNKeyPair
      BlockDeviceMappings:
      - DeviceName: /dev/sda1
        Ebs:
          VolumeType: gp2
          VolumeSize: 16
      ImageId: !Ref AmiId
      InstanceType: !Ref InstanceType
      InstanceInitiatedShutdownBehavior: stop
      DisableApiTermination: false
      IamInstanceProfile: !Ref OpenVPNIamProfile
      NetworkInterfaces:
      - AssociatePublicIpAddress: true
        DeviceIndex: "0"
        GroupSet:
        - !Ref OpenVPNSecurityGroup
        SubnetId: !Ref PublicSubnet
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash -xe
          
          git clone https://github.com/senad-dizdarevic/OpenVPN.git /root/OpenVPN
          
          cat <<EOF > /root/start_OpenVPN.sh
          #!/bin/bash -xe

          #VAR
          ADMINUSER="${AdminFullName}"
          EMAIL="${Email}"
          ORG="${Organisation}"
          COMPANY="${Company}"
          CITY="${AWS::Region}"
          EOF

          cat /root/OpenVPN/AWS/bash.sh >> /root/start_OpenVPN.sh
          rm -rf /root/OpenVPN
          chmod -x /root/start_OpenVPN.sh
          bash /root/start_OpenVPN.sh
          cat <<EOF > ~/mycron
          0 0 * * * yum -y update --security
          EOF
          crontab ~/mycron
          /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource myASG --region ${AWS::Region}
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.Ec2
        - Key: Description
          Value: OpenVPN instance for testing and configuring simple one click monitoring solution.
  # Creat EIP for OpenVPN
  ElasticIP:
    Type: AWS::EC2::EIP
    Properties:
      InstanceId: !Ref OpenVPN
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.EIP
  # Creat Security grop for allowing the ingres on port 1194 and 22.
  OpenVPNSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref VpcID
      GroupName: !Sub ${ProjectName}.SG
      GroupDescription: Security group for OpenVPN
      SecurityGroupIngress:
      - IpProtocol: tcp
        FromPort: 22
        ToPort: 22
        CidrIp: !Ref SSHSourceCidr
      - IpProtocol: udp
        FromPort: 1194
        ToPort: 1194
        CidrIp: !Ref SSHSourceCidr
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.SG
  # Creat IAM profile for OpenVPN instance.
  OpenVPNIamProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: "/"
      Roles: [!Ref OpenVPNRole]
  # Creat Role for OpenVPN instance.
  OpenVPNRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: !Sub ${ProjectName}.AllowDescribeRole
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
  # Creat Policy for allowing Describe*.
  OpenVPNPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: !Sub ${ProjectName}.AllowDescribePolicy
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - "ec2:DescribeTags"
              - "ec2:DescribeRegions"
              - "ec2:DescribeInstances"
            Resource: "*"
      Roles:
        - !Ref OpenVPNRole
#Names and values for the resorces.
Outputs:
  OpenVPNIP:
    Description: OpenVPN Public IP
    Value: !GetAtt OpenVPN.PublicIp
  OpenVPNUser:
    Description: Connect to the instance and run as sudo user to finish installing.
    Value: sudo bash start_OpenVPN.sh
```