---
title: Send Raw Email using AWS SES
date: 2023-10-20 12:00:00
categories: [AWS]
tags: [aws, ses]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

The script is designed to construct an email message in Multipurpose Internet Mail Extensions (MIME) format. This email is structured with headers and encompasses both HTML content and a plain text attachment.

## **Prerequisites**

Before you can use the script, you need to ensure you have the following prerequisites in place:

1.  **AWS CLI**: Make sure you have the AWS CLI (Command Line Interface) installed and configured with the necessary credentials. You can install and configure the AWS CLI by following the official AWS documentation: [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
    
2.  **Access to AWS SES**: You must have access to AWS SES to send emails. Ensure that your AWS credentials have the required permissions to use SES.

2. **HTML Template File**: Have the `tmp.html` file ready, containing the desired message.

3. **Base64 Encoded Attachment**: Ensure that the file you intend to send as an attachment is encoded in Base64 format.

## **Creating the script**
```shell
cat <<EOF >  send_ses
#!/bin/bash

FROM="\$1"
TO="\$2"
CONTENT="\$3"
NAME="\$4"
REGION="\$5"
HTML="\$(cat tmp.html)"

CONTENT="From: \$FROM
To: \$TO
Subject: AWS Credentials
MIME-Version: 1.0
Content-type: Multipart/Mixed; boundary=\"NextPart\"

--NextPart
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

\$HTML

--NextPart
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=\"\$NAME.txt\"
Content-Transfer-Encoding: base64

\$CONTENT
--NextPart--"

ENCODED=\$(echo -n "\$CONTENT" | base64 | sed ':a;N;$!ba;s/\n/\\n/g')
JSON="{\"Data\": \"\$ENCODED\"}"

aws ses send-raw-email --region "\$REGION" --raw-message "\$JSON"
EOF

chmod +x send_ses
```

## **Usage**

Run the script with the required arguments in the following format:
    
```shell
./send_ses "from@example.com" "to@example.com" "base64_encoded_content" "file_name" "aws_region"
```
   > Replace:<br>
   `from@example.com` with the sender's email address<br>
   `to@example.com` with the recipient's email address<br>
   `base64_encoded_content` with the base64-encoded content you want to send as an attachment. You can use `$(cat "input" | base64)`<br>
   `file_name` with the desired name for the attachment file (without an extension)<br>
   `aws_region` with the AWS Region in which you have SES Identity verified
   {: .prompt-tip }

