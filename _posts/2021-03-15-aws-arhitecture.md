---
title: AWS Architecture
date: 2021-03-15 12:00:00
categories: [AWS, AWS Basics]
tags: [aws, architecture]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

## Decoupled and Event-Driven Architecture
-   Monolithic Applications are essentially tightly coupled together and had a lot of built-in dependencies against each other
    
-   By using a decoupled architecture you are building a solution put together using different components and services that can operate and execute independently of one another
    
-   Each service within a decoupled environment communicates with others using specific interfaces which remain constant throughout its development
    
-   Services in an event-driven architecture are triggered by events that occur within the infrastructure
    
-   A Producer is an element within the infrastructure that will push an event to the event router
    
-   The Event Router then processes the event and takes the necessary action in pushing the outcome to the consumers
    
-   The Consumer executes the appropriate action as requested
    

## Simple Queue Service
-   It is a service that handles the delivery of messages between components
    
-   SQS is a fully managed service that works with serverless systems, microservices, and distributed architectures
    
-   It has the capability of sending, storing, and receiving messages at scale without dropping message data
    
-   It is possible to configure the service using the AWS Management Console, the AWS CLI, or AWS SDKs
    

## Visibility Timeout
-   When a message is retrieved by a consumer, the visibility timeout is started
    
-   The default time is 30 seconds
    
-   It can be set up to as long as 12 hours
    
-   If the visibility timeout expires, the message will become available again in the queue for other consumers to process
    

## SQS Standard Queues
-   Standard queues support at-least-once delivery of messages
    
-   They offer their best effort on trying to preserve the message ordering
    
-   They provide an almost unlimited number of transactions per second
    

-   Unlimited Throughput
    
-   At-least-once delivery
    
-   Best-effort ordering
    

## SQS FIFO Queues
-   The order of messages is maintained and there are no duplicates
    
-   A limited number of transactions per second (defaulted to 300 TPS)
    
-   Batching allows you to perform actions against 10 messages at once with a single action
    
-   High Throughput
    
-   First In First Out delivery
    
-   Exactly-once processing


## Dead-Letter Queue
-   The dead-letter queue sends messages that fail to be processed
    
-   This could be the result of code within your application, corruption within the message or simply missing information
    
-   If the message can't be processed by a consumer after a maximum number of tries specified, the queue will send the message to a DLQ
    
-   By viewing and analyzing the content of the message it might be possible to identify the problem and ascertain the source of the issue
    
-   The DLQ must have the same queue type as the source it used against
    

## Simple Notification Service
-   SNS is used as a publish/subscribe messaging service
    
-   SNS is centered around topics. You can think of a topic as a group for collecting messages
    
-   Users or endpoints can then subscribe to this topic, where messages or events are published
    
-   When a message is published, ALL subscribers to that topic receive a notification of that message
    
-   SNS is a managed service and highly scalable, allowing you to distribute messages automatical to all subscribers across your environment, including mobile devices
    
-   It can be configured with the AVVS management console the CLI or with the AWS SDK
    

## SNS Topics
-   SNS uses the concept of publishers and subscribers
    
-   SNS offers methods of controlling specific access to your topics through a topic policy. For example, you can restrict which protocol subscribers can use, such as SMS or HTTPS, or only allow access to this topic for a specific user
    
-   The policy follows the same format as IAM policies.
    

## Stream Processing
-   Stream processing is used to collect, process, and query data in either real-time or near real-time to detect anomalies, generate awareness, or gain insight
    
-   Real-time data processing is needed because, for some types of information, the data has an actionable value at the moment it was collected and its value diminishes, rapidly, over time.
    

## Batch processing
-   Data is collected, stored, and analyzed in chunks of a fixed size on a regular schedule
    
-   The schedule depends on the frequency of data collection and the related value of the insight gained
    
-   Value = At the center of stream processing
    

## Stream Processing
-   Created to address issues of latency, session boundaries, and inconsistent load
    
-   The term streaming is used to describe information as it flows continuously without a beginning or an end
    

## Never-ending Data
-   Best processed while it is in-flight
    
    Batch processing is built around a data-at-rest architecture: before processing can begin, the collection has to be stopped, and the data must be stored
    
-   Subsequent batches of data bring with them the need to aggregate data across multiple batches.
    
-   In contrast, streaming architectures handle never-ending data streams naturally with grace
    
-   Using streams, patterns can be detected, results inspected, and multiple streams can be examined simultaneously
    

## Limited Storage Capacity
-   Sometimes, the volume of data is larger than the existing storage capacity
    
-   Using streams, the raw data can be processed in real-time and then retain only the information and insight that is useful
    

## Streams Flow With Time
-   Stream processing naturally fits with time-series
    
-   data and the detection of patterns over time
    
-   Time series data, such as that produced by IoT sensors, is the most continuous type of data that can be streamed
    
-   IoT devices are a natural fit into a streaming data architecture
    

## Reactions in Real Time
-   Almost no lag time in between when events happen, insights are derived, and actions are taken
    
-   Actions and analytics are up-to-date and reflect data while it is still fresh, meaningful, and valuable
    

## Decoupled Architectures Improve Operational Efficiency
-   Streaming reduces the need for large and expensive shared databases: each stream processing application maintains its own data and state, which is made simple by the stream processing framework
    
-   Stream processing fits naturally inside a microservices architecture
    

## IMPORTANCE OF DATA STREAMING
-   Real-time trading of commodities
    
-   Global product launches
    
-   Target markets
    

## Amazon Kinesis
-   Amazon Kinesis was designed to address the complexity and costs of streaming data into the AWS cloud
    
-   Kinesis makes it easy to collect, process, and analyze various types of data streams such as event logs, social media feeds, clickstream data, application data, and IoT sensor data in real time or near real-time
    
-   Data in transit is protected using TLS, the Transport Layer Security Protocol
    

## Amazon Kinesis is composed of four services:
-   Kinesis Video Streams
    
-   Kinesis Data Streams
    
-   Kinesis Data Firehose
    
-   Kinesis Data Analytics
    
-   Kinesis Video Streams is used to do stream processing on binary-encoded data, such as audio and video
    
-   Kinesis Data Streams, Kinesis Data Firehose, and Kinesis Data Analytics are used to stream base64 text-encoded data.  This text-based information includes sources such as logs, click-stream data, social media feeds, financial transactions, in-game player activity, geospatial services, and telemetry from IoT devices
    

## Streaming data frameworks are described as having five layers
-   Source
    
-   Stream Ingestion
    
-   Stream Storage
    
-   Stream Processing
    
-   Destination
    
-   Inside Kinesis Data Streams, the Data Records are immutable
    
-   Amazon Kinesis Video Streams is designed to stream binary-encoded data into AWS from millions of sources
    
-   Kinesis Video Streams supports the open-source project WebRTC
    
-   Amazon Kinesis Data Streams is a highly customizable streaming solution available from AWS
    
-   Producers put Data Records into a Data Stream
    
-   Kinesis Producers can be created using the AWS SDKs, the Kinesis Agent, the Kinesis APIs, or the Kinesis Producer Library, KPL
    
-   A Kinesis Data Stream is a set of Shards. 
    
-   A shard contains a sequence of Data Records. 
    
-   Data Records are composed of a Sequence Number, a Partition Key, and a Data Blob, and they are stored as an immutable sequence of bytes
    
-   There is also a charge for retrieving data older than 7 days from a Kinesis Data Stream using the GetRecords() API call
    
-   There is no charge for long-term data retrieval when using the Enhanced Fanout Consumer using the SubscribeToShard() API
    
-   Consumers--Amazon Kinesis Data Streams Applications--get records from Kinesis Data Streams and process them
    
-   The Classic Consumer will Pull data from the Stream (Polling mechanism)
    
-   Enhanced Fan Out, consumers can subscribe to a shard, this results in data being pushed automatically from the shard into a  consumer application
    
-   Amazon Kinesis Data Firehose is a data streaming service from AWS like Kinesis Data Streams, being fully managed, is really a streaming delivery service for dana
    
-   Kinesis Data Firehose uses Producers to load data into streams in batches and, once inside the stream, the data is delivered to a data store
    
-   Amazon Kinesis Data Firehose buffers incoming streaming data before delivering it to its destination
    
-   Kinesis Data Firehose could deliver data to four data stores; Amazon S3, Amazon Redshift, Amazon Elasticsearch, Splunk, generic HTTP endpoints as well as HTTP endpoints for the 3rd-party providers Datadog, MongoDB Cloud, and New Relic
    
-   Kinesis Data Firehose will automatically scale as needed
    
-   Kinesis Data Analytics has the ability to read from the stream in real time and do aggregation and analysis on data while it is in motion
    
-   When using Kinesis Data Firehose with Kinesis Data Analytics, data records can only be queried using SQL
    
-   Kinesis Video Streams pricing is based on the volume of data ingested, the volume of data consumed, and data stored across all the video streams in an account
    
-   Kinesis Data Streams pricing is a little more complicated.  There is an hourly cost based on the number of shards in a Kinesis Data Stream. There is a separate charge when producers put data into the stream
    
-   For consumers, charges are dependent on whether or not  Enhanced Fan Out is being used.  If it is, charges are based on the amount of data and the number of consumers
    
-   Firehose charges are based on the amount of data put into a delivery stream, for the amount of data converted by Data Firehose, and, if data is sent to a VPC, the amount of data delivered as well as an hourly charge per Availability Zone
    
-   Amazon Kinesis Data Analytics changes an hourly rate based on the number of Amazon Kinesis Processing Units or KPUs used to run a streaming application
