---
title: CloudFormation - Backend and Frontend Infrastructure
date: 2023-03-01 12:00:00
categories: [Projects, ECS]
tags: [aws, ecs, cloudformation]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Create AWS Infrastructure for the backend services.

## Backend template
```shell
#!/bin/bash

HZID="$1"
HZN="$2"
CERT="$3"

cat <<EOF >> backend.yml
---
AWSTemplateFormatVersion : 2010-09-09
Description: Backend infrastructure

### Set Parameters (values to pass to your template at runtime)
Parameters:
  ProjectName:
    Description: This name will be used for for resource names, keyname and tagging.
    Type: String
    Default: App
  Environment:
    Description: Deployment environment.
    Type: String
    AllowedValues:
      - dev
      - prod
    Default: dev
  VpcCidr:
    Description: What is the CIDR Block of IPv4 IP addresses for VPC?
    Type: String
    Default: 10.1.0.0/16
    AllowedPattern: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?\$"
  PublicSubnetAZaCidr:
    Description: Please enter the IP range (CIDR notation) for the public subnet in the Availability Zone "A"
    Type: String
    AllowedPattern: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?\$"
    Default: 10.1.10.0/24
  PublicSubnetAZbCidr:
    Description: Please enter the IP range (CIDR notation) for the public subnet in the Availability Zone "B"
    Type: String
    AllowedPattern: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?\$"
    Default: 10.1.20.0/24
  PrivateSubnetAZaCidr:
    Description: Please enter the IP range (CIDR notation) for the public subnet in the Availability Zone "A"
    Type: String
    AllowedPattern: "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(/([0-9]|[1-2][0-9]|3[0-2]))?\$"
    Default: 10.1.30.0/24
  Certificate:
    Description: What is the Certificate ID?
    Type: String
    Default: $CERT
  HostedZoneId:
    Description: What is the Hosted Zone Id?
    Type: String
    Default: $HZID
  HostedZoneName:
    Description: What is the Hosted Zone Name?
    Type: String
    Default: $HZN
  PrefixListId:
    Description: Prefix List Id for CloudFront IP
    Type: String
    Default: pl-4fa04526

### Metadata (provide additional information about the template)
Metadata:
  AWS::CloudFormation::Interface:
    ParameterGroups:
      - 
        Label:
          default: "VPC for Faregate"
        Parameters:
          - ProjectName
          - Environment
          - VpcCidr
          - PublicSubnetAZaCidr
          - PublicSubnetAZbCidr
          - PrivateSubnetAZaCidr
          - Certificate
          - HostedZoneName
          - HostedZoneId
          - PrefixListId
    
    ParameterLabels:
      ProjectName:
        default: "Project"
      Environment:
        default: "Name"
      VpcCidr:
        default: "VPC CIDR"
      PublicSubnetAZaCidr:
        default: "PublicSubnet A"
      PublicSubnetAZbCidr:
        default: "PublicSubnet B"
      PrivateSubnetAZaCidr:
        default: "PrivateSubnet A"
      Certificate:
        default: "Certificate ID"
      HostedZoneName:
        default: "Hosted Zone Name"
      HostedZoneId:
        default: "Hosted Zone Id"
      PrefixListId:
        default: "Prefix List Id"

Resources:
### VPC
  Vpc:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: !Ref VpcCidr
      InstanceTenancy: default
      EnableDnsSupport: true
      EnableDnsHostnames: true
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.VPC'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

### IGW
  InternetGateway: 
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.IGW'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
    

  VpcInternetGatewayAttachment: 
    Type: AWS::EC2::VPCGatewayAttachment
    Properties: 
      VpcId: !Ref Vpc
      InternetGatewayId: !Ref InternetGateway

### Subnets
  PublicSubnetAZa:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref Vpc
      CidrBlock: !Ref PublicSubnetAZaCidr
      AvailabilityZone: !Select [0, !GetAZs ""]
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.Public.Zone.A'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  PublicSubnetAZb:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref Vpc
      CidrBlock: !Ref PublicSubnetAZbCidr
      AvailabilityZone: !Select [1, !GetAZs ""]
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.Public.Zone.B'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  PrivateSubnetAZa:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref Vpc
      CidrBlock: !Ref PrivateSubnetAZaCidr
      AvailabilityZone: !Select [0, !GetAZs ""]
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.Private.Zone.A'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
      
### RouteTables
  PublicRouteTable: 
    Type: AWS::EC2::RouteTable
    Properties: 
      VpcId: !Ref Vpc
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.Public.RouteTable'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
  
  PrivateRouteTableA: 
    Type: AWS::EC2::RouteTable
    Properties: 
      VpcId: !Ref Vpc
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.Private.RouteTable'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  PublicSubnetAZaRouteTable:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PublicRouteTable  
      SubnetId:  !Ref PublicSubnetAZa

  PublicSubnetAZbRouteTable:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      RouteTableId: !Ref PublicRouteTable  
      SubnetId:  !Ref PublicSubnetAZb
  
  PrivateSubnetAZaRouteTable: 
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties: 
      RouteTableId: !Ref PrivateRouteTableA
      SubnetId: !Ref PrivateSubnetAZa

  RouteToNAT1: 
   Type: AWS::EC2::Route
   Properties: 
     DestinationCidrBlock: 0.0.0.0/0
     RouteTableId: !Ref PrivateRouteTableA
     NatGatewayId: !Ref NATGatewayA

  RouteToInternetGateway: 
    Type: AWS::EC2::Route
    DependsOn: VpcInternetGatewayAttachment
    Properties: 
      DestinationCidrBlock: 0.0.0.0/0
      RouteTableId: !Ref PublicRouteTable
      GatewayId: !Ref InternetGateway

### NatGateway
  ElasticIP1:
    Type: AWS::EC2::EIP
    Properties:
      Domain: vpc
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.EIP1'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  NATGatewayA:
    Type: AWS::EC2::NatGateway
    DependsOn: VpcInternetGatewayAttachment
    Properties:
      AllocationId: !GetAtt ElasticIP1.AllocationId
      SubnetId: !Ref PublicSubnetAZa
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.NAT1'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

### Load Balancer
  ALB:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Name: !Sub '\${ProjectName}-\${Environment}-\${AWS::Region}-ALB'
      Scheme: internet-facing
      IpAddressType: 'ipv4'
      Type: application
      SecurityGroups: 
        - !GetAtt ALBSecurityGroup.GroupId
      Subnets:
      - !Ref PublicSubnetAZa
      - !Ref PublicSubnetAZb
      Tags:
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  TargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      HealthCheckIntervalSeconds: 60
      HealthCheckPath: /
      HealthCheckProtocol: HTTP
      HealthCheckTimeoutSeconds: 5
      HealthyThresholdCount: 5
      TargetType: ip
      Matcher:
        HttpCode: 200-499
      Name: !Sub '\${Environment}-App-Fargate-TG'
      Port: 80
      Protocol: HTTP
      UnhealthyThresholdCount: 3
      VpcId: !Ref Vpc

  HTTPSListener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      Certificates:
      - CertificateArn: !Ref Certificate
      DefaultActions:
      - TargetGroupArn: !Ref TargetGroup
        Type: forward
      LoadBalancerArn: !Ref ALB
      Port: 443
      Protocol: 'HTTPS'
      SslPolicy: 'ELBSecurityPolicy-2016-08'

  HTTPListener:
    Type: 'AWS::ElasticLoadBalancingV2::Listener'
    Properties:
      DefaultActions:
      - Type: redirect
        RedirectConfig:
          Port: '443'
          Protocol: HTTPS
          StatusCode: HTTP_301
      LoadBalancerArn: !Ref ALB
      Port: 80
      Protocol: HTTP

### DNS
  DnsRecords:
    Type: AWS::Route53::RecordSetGroup
    DependsOn: ALB
    Properties:
      HostedZoneId: !Ref HostedZoneId
      Comment: Zone apex alias targeted to myELB LoadBalancer.
      RecordSets:
      - Name: !Sub App-bck.\${HostedZoneName}
        Type: A
        AliasTarget:
          HostedZoneId: !GetAtt 'ALB.CanonicalHostedZoneID'
          DNSName: !GetAtt 'ALB.DNSName'
    
### ECS Cluster
  ECSCluster:
    Type: AWS::ECS::Cluster
    Properties:
      ClusterName: !Sub '\${ProjectName}-\${Environment}-ECS-cluster'
      ServiceConnectDefaults: 
        Namespace: !Sub '\${ProjectName}-\${Environment}-ECS-App'
      Tags:
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

### EFS
  EFSMountTargetDB:
    Type: AWS::EFS::MountTarget
    Properties:
      FileSystemId: !ImportValue AppAppSystemFiles
      SubnetId: !Ref PrivateSubnetAZa
      SecurityGroups: [!Ref EFSTargetSecurityGroup]

### SecurityGroups
  ALBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      VpcId: !Ref Vpc
      GroupDescription: !Sub '\${ProjectName} \${Environment} ALB Security Group'
      SecurityGroupIngress:
      - SourcePrefixListId: !Ref PrefixListId
        FromPort: 80
        ToPort: 80
        IpProtocol: 'tcp'
      - CidrIp: '0.0.0.0/0'
        FromPort: 443
        ToPort: 443
        IpProtocol: 'tcp'
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.ALB.SG'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  AppSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    DependsOn: ALBSecurityGroup
    Properties:
      VpcId: !Ref Vpc
      GroupDescription: Access to the Fargate service and the tasks/containers that run on them
      SecurityGroupIngress:
      - CidrIp: !Ref VpcCidr
        FromPort: 3306
        ToPort: 3306
        IpProtocol: 'tcp'
      - SourceSecurityGroupId: !Ref ALBSecurityGroup
        FromPort: 80
        ToPort: 80
        IpProtocol: 'tcp'
      - SourceSecurityGroupId: !Ref ALBSecurityGroup
        FromPort: 443
        ToPort: 443
        IpProtocol: 'tcp'
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.AppFargate.SG'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  EFSTargetSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: EFS Mount Access
      VpcId: !Ref Vpc
      SecurityGroupIngress:
      - CidrIp: !Ref VpcCidr
        IpProtocol: '-1'
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.EFS.SG'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
  
  DBSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    DependsOn: EFSTargetSecurityGroup
    Properties:
      VpcId: !Ref Vpc
      GroupDescription: Access to the Fargate service and the tasks/containers that run on them
      SecurityGroupIngress:
      - CidrIp: !Ref VpcCidr
        FromPort: 3306
        ToPort: 3306
        IpProtocol: 'tcp'
      - SourceSecurityGroupId: !Ref EFSTargetSecurityGroup
        IpProtocol: '-1'
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.DBFargate.SG'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
      
### Roles
  EcsTaskExecutionRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
        - Effect: Allow
          Principal:
            Service: [ecs-tasks.amazonaws.com]
          Action: ['sts:AssumeRole']
      Path: /
      Policies:
        - PolicyName: !Sub '\${ProjectName}.\${Environment}.EcsTaskExecutionRolePolicy'
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
            - Effect: Allow
              Action:
                - 'ecr:GetAuthorizationToken'
                - 'ecr:BatchCheckLayerAvailability'
                - 'ecr:GetDownloadUrlForLayer'
                - 'ecr:BatchGetImage'
                - 'logs:CreateLogStream'
                - 'logs:PutLogEvents'
                - 'logs:CreateLogGroup'
                - 'elasticfilesystem:ClientWrite'
                - 'elasticfilesystem:ClientMount'
              Resource: '*'
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.EcsTaskExecutionRole'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
  
  EcsTaskRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
        - Effect: Allow
          Principal:
            Service: [ecs-tasks.amazonaws.com]
          Action: ['sts:AssumeRole']
      Path: /
      Policies:              
        - PolicyName: !Sub '\${ProjectName}.\${Environment}.SESPolicy'
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
            - Effect: Allow
              Action:
              - ses:*
              Resource: '*'
        - PolicyName: !Sub '\${ProjectName}.\${Environment}.EXECintoAppPolicy'
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
            - Effect: Allow
              Action:
              - 'ssmmessages:CreateControlChannel'
              - 'ssmmessages:CreateDataChannel'
              - 'ssmmessages:OpenControlChannel'
              - 'ssmmessages:OpenDataChannel'
              Resource: '*'

  EcsDBTaskRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Statement:
        - Effect: Allow
          Principal:
            Service: [ecs-tasks.amazonaws.com]
          Action: ['sts:AssumeRole']
      Path: /
      Policies:              
        - PolicyName: !Sub '\${ProjectName}.\${Environment}.EFSDBPolicy'
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
            - Effect: Allow
              Action:
              - 'elasticfilesystem:ClientMount'
              - 'elasticfilesystem:ClientWrite'
              Resource: '*'
        - PolicyName: !Sub '\${ProjectName}.\${Environment}.EXECintoDBPolicy'
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
            - Effect: Allow
              Action:
              - 'ssmmessages:CreateControlChannel'
              - 'ssmmessages:CreateDataChannel'
              - 'ssmmessages:OpenControlChannel'
              - 'ssmmessages:OpenDataChannel'
              Resource: '*'
      Tags:
      - {Key: Name, Value: !Sub '\${ProjectName}.\${Environment}.EcsDBTaskRole'}
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

### Parameters
  ALBSGParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.ALB.SG.App'
      Type: String
      Value: !Ref ALBSecurityGroup
      Description: SSM Parameter for security group

  AppSGParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.AppSG.App'
      Type: String
      Value: !Ref AppSecurityGroup
      Description: SSM Parameter for App security group

  DBSGParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.SG.App.DataBase'
      Type: String
      Value: !Ref DBSecurityGroup
      Description: SSM Parameter for DataBase security group

  PublicSubnetAParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.PublicSubnetA.App'
      Type: String
      Value: !Ref PublicSubnetAZa
      Description: SSM Parameter for subnet

  PublicSubnetBParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.PublicSubnetB.App'
      Type: String
      Value: !Ref PublicSubnetAZb
      Description: SSM Parameter for subnet

  PrivateSubnetParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.PrivateSubnet.App'
      Type: String
      Value: !Ref PrivateSubnetAZa
      Description: SSM Parameter for subnet

  EFSMountTargetDBParameterDB:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.EFSMountTargetDB.App'
      Type: String
      Value: !Ref EFSMountTargetDB
      Description: SSM Parameter for EFSMountPrivateTarget

  ECSClusterParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.ECSCluster.App'
      Type: String
      Value: !Ref ECSCluster
      Description: SSM Parameter for ECSCluster

  EcsTaskExecutionRoleParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.EcsTaskExecutionRole.App'
      Type: String
      Value: !GetAtt EcsTaskExecutionRole.Arn
      Description: SSM Parameter for EcsTaskExecutionRole
  
  EcsTaskRoleParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.EcsTaskRole.App'
      Type: String
      Value: !GetAtt EcsTaskRole.Arn
      Description: SSM Parameter for EcsTaskRoleParameter

  EcsDBTaskRoleParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '\${Environment}.EcsDBTaskRole.App'
      Type: String
      Value: !GetAtt EcsDBTaskRole.Arn
      Description: SSM Parameter for EcsDBTaskRoleParameter
EOF
```

## Frontend template
Run Bash script to create a CloudFormation template for running the CloudFront distribution using a private S3 bucket and creating Rout53 RecordSet for the domain. 

```shell
#!/bin/bash

HZID="$1"
HZN="$2"
CERT="$3"

cat <<EOF >> frontend.yml
---
AWSTemplateFormatVersion : 2010-09-09
Description: Project CloudFront distributions Stack

### Set Parameters (values to pass to your template at runtime)
Parameters:
  Environment:
    Type: String
    Default: dev
    AllowedValues:
    - dev
    - prod
    Description: Choose environment to deploy
  DomainPrefix:
    Type: String
    Default: App-fe
    Description: Choose domain prefix for Construction Site Inventory app
  ProjectName:
    Type: String
    Default: App
    Description: This will be used for for resource names, keyname and tagging
  SiteBucket:
    Type: String
    Default: App-app
    Description: Prefix for Project website
  HostedZone:
    Type: String
    Default: $HZN
    Description: Hosted zone for project

Resources:
### Route53 record for CloudFront distributions
  DnsRecordCdnDistribution:
    Type: AWS::Route53::RecordSetGroup
    DependsOn: CdnDistribution
    Properties:
      HostedZoneId: $HZID
      Comment: !Sub \${ProjectName} frontend DNS records.
      RecordSets:
      - Name: !Sub \${DomainPrefix}.\${HostedZone}
        Type: A
        AliasTarget:
          HostedZoneId: Z2FDTNDATAQYW2
          DNSName: !GetAtt CdnDistribution.DomainName
  
### CloudFront distributions
  CdnDistribution:
    Type: AWS::CloudFront::Distribution
    Properties:
      DistributionConfig:
        Comment: Project App
        Aliases: 
          - !Sub '\${DomainPrefix}.\${HostedZone}'
        Enabled: true
        PriceClass: PriceClass_100
        HttpVersion: http2and3
        DefaultRootObject: index.html
        CustomErrorResponses:
        - ErrorCode: 403
          ResponsePagePath: '/index.html'
          ResponseCode: '200'
          ErrorCachingMinTTL: 300
        - ErrorCode: 404
          ResponsePagePath: '/index.html'
          ResponseCode: '200'
          ErrorCachingMinTTL: 300
        DefaultCacheBehavior:
          TargetOriginId: !Sub "\${SiteBucket}-\${Environment}"
          ViewerProtocolPolicy: redirect-to-https
          DefaultTTL: "0"
          AllowedMethods: [DELETE, GET, HEAD, OPTIONS, PATCH, POST, PUT]
          CachedMethods: [HEAD, GET]
          Compress: true
          ForwardedValues:
            QueryString: false
        Logging:
          Bucket: !Sub 'App-cf-logs-\${Environment}.s3.amazonaws.com'
          IncludeCookies: true
          Prefix: !Sub 'cloudfront-logs-App-\${DomainPrefix}/'
        Origins:
        - DomainName: !Sub '\${SiteBucket}-\${Environment}.s3.eu-west-1.amazonaws.com'
          Id: !Sub "\${SiteBucket}-\${Environment}"
          S3OriginConfig:
            OriginAccessIdentity: !Join ['', ['origin-access-identity/cloudfront/', !ImportValue AppCloudFrontOAI]]
        ViewerCertificate:
          AcmCertificateArn: $CERT
          SslSupportMethod: sni-only
          MinimumProtocolVersion: TLSv1.2_2021
      Tags:
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}
EOF
```