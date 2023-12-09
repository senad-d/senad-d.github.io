---
title: OpenVPN CloudFormation
date: 2023-02-01 12:00:00
categories: [Projects]
tags: [aws, openvpn, cloudformation]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

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
    Description: Enter email address for Amazon Simple Email Service
    Type: String
    Default: example@email.com
  Organization:
    Description: Enter Organization unit name
    Type: String
    Default: DevOps-team
  Company:
    Description: Enter Company name
    Type: String
    Default: Valcon
  VpcID:
    Description: Which VPC would you like to use for Ec2 instance?
    Type: AWS::EC2::VPC::Id
    ConstraintDescription : VPC must exist
  PublicSubnet:
    Description: Which Public Subnet would you like to use for the Ec2 instance?
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
          - Organization
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
      Organization:
        default: "Organization unit name"
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
# Specify the stack resources and their properties.
Resources:
  # Create ENI
  VPNENI:
      Type: AWS::EC2::NetworkInterface
      Properties:
         Description: OpenVPN ENI for FlowLogs
         SubnetId: !Ref PublicSubnet
         GroupSet:
         - !Ref OpenVPNSecurityGroup
         Tags:
         - Key: Name
           Value: !Sub ${ProjectName}.VPN-ENI
         - Key: Project
           Value: !Sub ${ProjectName}
  # Create EIP for OpenVPN
  ElasticIP:
    Type: AWS::EC2::EIP
    Properties:
      InstanceId: !Ref OpenVPN
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.VPN-EIP
        - Key: Project
          Value: !Sub ${ProjectName}
  # S3 bucket for the list of users
  UsersBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub ${ProjectName}.users-bucket
      LifecycleConfiguration: 
        Rules: 
        - Id: 120 day delete artifacts rule
          Prefix: !Sub '${ProjectName}.users'
          Status: Enabled
          ExpirationInDays: 120
      AccessControl: Private
      VersioningConfiguration: 
        Status: Enabled
      Tags:
        - Key: Project
          Value: !Sub ${ProjectName}
  # UsersBucket bucket policy
  UsersBucketPolicy: 
    Type: AWS::S3::BucketPolicy 
    DependsOn: OpenVPN
    Properties:
      Bucket: !Ref UsersBucket
      PolicyDocument: 
        Version: "2008-10-17"
        Statement:
          -
            Action:
              - s3:ListBucket
              - s3:GetObject
              - s3:PutObject
            Effect: Allow
            Resource:
              - !Sub 'arn:aws:s3:::${UsersBucket}'
              - !Sub 'arn:aws:s3:::${UsersBucket}/*'
            Principal:
              AWS:
                - !Sub 'arn:aws:iam::${AWS::AccountId}:root'
                - !GetAtt OpenVPNRole.Arn
# Create EC2 Instance for the OpenVPN.
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
      - NetworkInterfaceId: !Ref VPNENI
        DeviceIndex: "0"
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash -xe
          
          git clone https://<token>@github.com/valconsee//VPN.git /root/OpenVPN
          
          cat <<EOF > /root/start_OpenVPN.sh
          #!/bin/bash -xe

          #VAR
          ADMINUSER="${AdminFullName}"
          EMAIL="${Email}"
          ORG="${Organization}"
          COMPANY="${Company}"
          CITY="${AWS::Region}"
          PROJECT="${ProjectName}"
          EOF

          cat /root/OpenVPN/AWS/bash.sh >> /root/start_OpenVPN.sh
          rm -rf /root/OpenVPN
          chmod -x /root/start_OpenVPN.sh
          bash /root/start_OpenVPN.sh
          cat <<EOF > ~/vpncron
          0 0 * * sat yum -y update --security
          1 0 * * * iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -o "$NETADAPT" -j MASQUERADE
          2 0 * * * iptables -t nat -I POSTROUTING -s 10.8.0.0/16 -d 10.0.0.0/16 -o "$NETADAPT" -j MASQUERADE
          3 0 * * * iptables-save
          EOF
          crontab ~/vpncron
          /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackName} --resource myASG --region ${AWS::Region}
      Tags:
        - Key: Name
          Value: !Sub ${ProjectName}.Ec2.${InstanceType}
        - Key: Description
          Value: !Sub OpenVPN EC2 instance for ${ProjectName}
        - Key: Project
          Value: !Sub ${ProjectName}
  # Create Security grope for allowing the ingres on port 1194 and 22.
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
          Value: !Sub ${ProjectName}.VPN-SG
        - Key: Project
          Value: !Sub ${ProjectName}
  # Create IAM profile for OpenVPN instance.
  OpenVPNIamProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: "/"
      Roles: [!Ref OpenVPNRole]
  # Create Role for OpenVPN instance.
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
  # Create Policy for allowing Describe.
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
  VPNssmPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: !Sub ${ProjectName}.AllowSSMPolicy
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - "ssm:ListDocuments"
              - "ssm:DescribeDocument*"
              - "ssm:GetDocument"
              - "ssm:DescribeInstance*"
            Resource: "*"
      Roles:
        - !Ref OpenVPNRole
  VPNs3Policy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: !Sub ${ProjectName}.AllowS3toEc2Policy
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - "s3:GetObject"
            Resource:
              - !Sub 'arn:aws:s3:::${UsersBucket}'
              - !Sub 'arn:aws:s3:::${UsersBucket}/*'
      Roles:
        - !Ref OpenVPNRole
  VPNsesPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: !Sub ${ProjectName}.AllowSESPolicy
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - "ses:SendEmail"
              - "ses:SendRawEmail"
            Resource: "*"
      Roles:
        - !Ref OpenVPNRole
  # Amazon Simple Email Service
  EmailVerification:
    Type: "AWS::SES::EmailIdentity"
    Properties:
        EmailIdentity: !Ref Email
  SESReceiptRuleSet:
    Type: "AWS::SES::ReceiptRuleSet"
    Properties:
      RuleSetName: "DefaultRuleSet"
  # Log
  LogRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
        - Effect: Allow
          Principal:
            Service: vpc-flow-logs.amazonaws.com
          Action: sts:AssumeRole
      Policies:
      - PolicyName: flowlogs-policy
        PolicyDocument:
          Version: 2012-10-17
          Statement:
          - Effect: Allow
            Action:
            - "logs:CreateLogStream"
            - "logs:PutLogEvents"
            - "logs:DescribeLogGroups"
            - "logs:DescribeLogStreams"
            Resource: !GetAtt LogGroup.Arn
  LogGroup:
    Type: AWS::Logs::LogGroup
    Properties:
      RetentionInDays: 90
  FlowLog:
    Type: AWS::EC2::FlowLog
    Properties:
      DeliverLogsPermissionArn: !GetAtt LogRole.Arn
      LogGroupName: !Ref LogGroup
      ResourceId: !Ref VPNENI
      ResourceType: NetworkInterface
      TrafficType: ALL
### Parameters
  ProjectParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${ProjectName}.project'
      Type: String
      Value: !Ref ProjectName
      Description: SSM Parameter for Project name
  EIPParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${ProjectName}.Ec2-Ip'
      Type: String
      Value: !GetAtt OpenVPN.PublicIp
      Description: SSM Parameter for OpenVPN EIP
    DependsOn: OpenVPN
  Ec2IpParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${ProjectName}.Ec2-Id'
      Type: String
      Value: !Ref OpenVPN
      Description: SSM Parameter for OpenVPN ec2 ID
    DependsOn: OpenVPN
  S3IdParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${ProjectName}.S3-Id'
      Type: String
      Value: !Ref UsersBucket
      Description: SSM Parameter for Users S3 bucket name
    DependsOn: UsersBucket
  EmailParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${ProjectName}.ses-email'
      Type: String
      Value: !Ref Email
      Description: SSM Parameter for SES email sending
    DependsOn: UsersBucket
#Names and values for the resources.
Outputs:
  OpenVPNIP:
    Description: OpenVPN Public IP
    Value: !GetAtt OpenVPN.PublicIp
  OpenVPNUser:
    Description: Connect to the instance and run as sudo user in the root directory to create user.
    Value: ./create_vpn_user <firstname-lastname>
```