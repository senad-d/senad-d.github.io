---
title: CloudFormation static Infrastructure
date: 2023-03-01 12:00:00
categories: [Projects, CSI]
tags: [aws, ecs, cloudformation]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

Create an AWS User to manage the infrastructure and give it permissions.
Use the CloudFormation template to create static resources for storing templates, data, and logs related to the application.

static_resources_ecs.yml

```shell
---
AWSTemplateFormatVersion : 2010-09-09
Description: Project backend infrastructure

# Set Parameters (values to pass to your template at runtime)
Parameters:
  ProjectName:
    Description: This name will be used for resource names, keyname and tagging.
    Type: String
    Default: App
  Environment:
    Description: Deployment environment.
    Type: String
    AllowedValues:
      - dev
      - prod
    Default: dev
  CreateS3Bucket:
      Type: String
      Default: 'true'
      AllowedValues:
      - 'true'
      - 'false'
      Description : Defines if S3 bucket will be created as part of this stack.

Conditions:
  IsDevelop: !Equals [!Ref Environment, dev]
  IsProduction: !Equals [!Ref Environment, prod]
  CreateBucket: !Equals [!Ref CreateS3Bucket, 'true']
  ReleasesBucketDevPolicy: !And
    - !Condition IsDevelop
    - !Condition CreateBucket

Resources:
### EFS
  ProjectAppSystemFiles:
    Type: 'AWS::EFS::FileSystem'
    Properties:
      AvailabilityZoneName: !Select [0, !GetAZs ""]
      BackupPolicy:
        Status: DISABLED
      PerformanceMode: generalPurpose
      Encrypted: false
      LifecyclePolicies:
        - TransitionToIA: AFTER_30_DAYS
        - TransitionToPrimaryStorageClass: AFTER_1_ACCESS
      FileSystemTags:
        - Key: Name
          Value: !Sub ${ProjectName}.FileSystem
    
### Logs
  LogGroup:
    Type: AWS::Logs::LogGroup
    Properties: 
      LogGroupName: !Sub '${ProjectName}-ECS-logs-${Environment}'
      RetentionInDays: 1

### ECR
  ECRepo:
    Type: AWS::ECR::Repository
    Properties: 
      LifecyclePolicy: 
        LifecyclePolicyText:
          '{
            "rules": [
              {
                "rulePriority": 1,
                "description": "Keep only five untagged images, expire all others",
                "selection": {
                    "tagStatus": "untagged",
                    "countType": "imageCountMoreThan",
                    "countNumber": 5
                },
                "action": {
                    "type": "expire"
                }
              }
            ]
          }'
        RegistryId: !Ref 'AWS::AccountId'
      RepositoryName: !Sub 'App-app-${Environment}-ecr'
      RepositoryPolicyText: 
        Version: "2012-10-17"
        Statement: 
          - 
            Sid: AllowPushPull
            Effect: Allow
            Principal: 
              AWS: 
                - !Sub 'arn:aws:iam::${AWS::AccountId}:assumed-role/****'
            Action: 
              - "ecr:GetDownloadUrlForLayer"
              - "ecr:BatchGetImage"
              - "ecr:BatchCheckLayerAvailability"
              - "ecr:PutImage"
              - "ecr:InitiateLayerUpload"
              - "ecr:UploadLayerPart"
              - "ecr:CompleteLayerUpload"
      Tags:
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

### CloudFront Origin Access Identity
  CloudFrontOAI:
    Type: AWS::CloudFront::CloudFrontOriginAccessIdentity
    Properties:
      CloudFrontOriginAccessIdentityConfig:
        Comment: !Sub 'Identity for ${ProjectName} CloudFront for Project app'

### S3 buckets for deployment
  ReleasesBucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    Condition: CreateBucket
    Properties:
      BucketName: !Sub 'csi-resources-${Environment}'
      LifecycleConfiguration: 
        Rules: 
        - Id: !If [IsProduction, 120 day delete artifacts rule, 45 day delete artifacts rule]
          Prefix: !Sub '${ProjectName}.'
          Status: Enabled
          ExpirationInDays: !If [IsProduction, 120, 45]
      AccessControl: Private
      VersioningConfiguration: 
        Status: Suspended
      Tags:
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

  ReleasesBucketPolicy: 
    Type: AWS::S3::BucketPolicy 
    Condition: ReleasesBucketDevPolicy
    Properties:
      Bucket: !Ref ReleasesBucket
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
              - !Sub 'arn:aws:s3:::${ReleasesBucket}'
              - !Sub 'arn:aws:s3:::${ReleasesBucket}/*'
            Principal:
              AWS:
                - !Sub 'arn:aws:iam::${AWS::AccountId}:root'

### S3 buckets for Frontend
  BucketFrontend:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    Condition: CreateBucket
    Properties:
      BucketName: !Sub 'csi-app-${Environment}'
      AccessControl: Private
      CorsConfiguration:
        CorsRules:
          - AllowedHeaders:
              - '*'
            AllowedMethods:
              - PUT
              - POST
              - DELETE
            AllowedOrigins:
              - '*'
            MaxAge: 0
          - AllowedHeaders:
              - '*'
            AllowedMethods:
              - GET
              - DELETE
            AllowedOrigins:
              - '*'
            MaxAge: 0
      VersioningConfiguration: 
        Status: Suspended
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true
      Tags:
      - {Key: Project, Value: !Ref ProjectName}  
      - {Key: Environment, Value: !Ref Environment}

  BucketPolicy:
    Type: AWS::S3::BucketPolicy
    Properties: 
      Bucket: !Ref BucketFrontend
      PolicyDocument: 
        Version: '2012-10-17'
        Statement:
        - Effect: Allow
          Principal:
            AWS: !Sub "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${CloudFrontOAI}"
          Action: 's3:GetObject'
          Resource: !Sub 'arn:aws:s3:::csi-app-${Environment}/*'

### S3 buckets for logging
  CFLogsBucket:
    Type: AWS::S3::Bucket
    DeletionPolicy: Retain
    Condition: CreateBucket
    Properties:
      BucketName: !Sub 'csi-cf-logs-${Environment}'
      AccessControl: Private
      VersioningConfiguration: 
        Status: Suspended
      Tags:
      - {Key: Project, Value: !Ref ProjectName}
      - {Key: Environment, Value: !Ref Environment}

### Parameters
  ProjectAppSystemFilesParameter:
      Type: AWS::SSM::Parameter
      Properties:
        Name: !Sub '${Environment}.CSIAppSystemFiles.App'
        Type: String
        Value: !Ref ProjectAppSystemFiles
        Description: SSM Parameter for SystemFiles

  LogGroupParameter:
      Type: AWS::SSM::Parameter
      Properties:
        Name: !Sub '${Environment}.LogGroup.App'
        Type: String
        Value: !Ref LogGroup
        Description: SSM Parameter for LogGroup

  ECRepoParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${Environment}.ECRepo.App'
      Type: String
      Value: !Ref ECRepo
      Description: SSM Parameter for ECRepo

  ReleasesBucketParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${Environment}.ReleasesBucket.App'
      Type: String
      Value: !Ref ReleasesBucket
      Description: SSM Parameter for ReleasesBucket

  BucketFrontendParameter:
    Type: AWS::SSM::Parameter
    Properties:
      Name: !Sub '${Environment}.BucketFrontend.App'
      Type: String
      Value: !Ref BucketFrontend
      Description: SSM Parameter for BucketFrontend

### Outputs
Outputs:
  ProjectAppSystemFiles:
    Description: EFS
    Value: !Ref ProjectAppSystemFiles
    Export:
      Name: ProjectAppSystemFiles

  BucketFrontend:
    Description: CloudFront Bucket
    Value: !Ref BucketFrontend
    Export:
      Name: ProjectBucketFrontend

  CloudFrontOAI:
    Description: CloudFront Bucket
    Value: !GetAtt CloudFrontOAI.Id
    Export:
      Name: ProjectCloudFrontOAI

```