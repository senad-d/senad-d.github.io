---
title: List all resources in AWS
date: 2022-05-11 12:00:00
categories: [Cloud, AWS]
tags: [aws, resources]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/backgroun.png?raw=true){: .shadow }

You can use the `Tag Editor`

1.  Go to AWS Console
2.  In the TOP Navigation Pane, click `Resource Groups`
3.  Click `Tag Editor`


![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/20221115145424.png?raw=true){: .shadow }

Here we can select either a particular region in which we want to search or select all regions from the dropdown. Then we can select actual resources we want to search for or click on individual resources.

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/20221115145556.png?raw=true){: .shadow }

Export the list as a CSV file and import it into Excel or LibreOffice and create a “Pivot Table” from the available data.
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/20221116100649.png?raw=true){: .shadow }


---

Here, you need to enter the region name and [configure AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) before trying this.

```shell
aws resourcegroupstaggingapi get-resources --region region_name
```

It will list all the recourses in the region in the following format.

```shell
- ResourceARN: arn:aws:cloudformation:eu-west-1:123456789101:stack/auction-services-dev/*******************************
  Tags:
  - Key: STAGE
    Value: dev
- ResourceARN: arn:aws:cloudformation:eu-west-1:********************
Tags:
-- More  --
```

---
## Alternative route

### [aws_list_all](https://github.com/JohannesEbke/aws_list_all)

List all resources in an AWS account, all regions, all services(*). Writes JSON files for further processing.