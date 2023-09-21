---
title: Slack incoming webhooks
date: 2021-05-02 12:00:00
categories: [Software, Slack]
tags: [slack, webhooks]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }

Incoming webhooks are a simple way to post messages from external sources into Slack. They make use of normal HTTP requests with a JSON payload, which includes the message and a few other optional details. You can include message attachments to display richly-formatted messages.

Adding incoming webhooks requires a bot user. If your app doesn't have a bot user, we’ll add one for you.

Each time your app is installed, a new Webhook URL will be generated.

Link: https://api.slack.com/apps


## Webhook URLs for Your Workspace

To dispatch messages with your webhook URL, send your message in JSON as the body of an `application/json` POST request.

Add this webhook to your workspace below to activate this curl example.

### **Sample curl request to post to a channel:**

```shell
curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' https://hooks.slack.com/services/T6CK3J83X/B04ACdXJC10/Xj4Yx5jWmlqRZ8S4Q5O0SNJN
```
