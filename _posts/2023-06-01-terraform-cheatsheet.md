---
title: Terraform Cheat Sheet
date: 2023-06-02 12:00:00
categories: [Terraform, Basics]
tags: [terraform, cheat-sheet]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/terraform-banner.png?raw=true){: .shadow }

## The 10 most useful Terraform commands

A key part of using Terraform is learning to use the Terraform CLI by understanding the configurations.

Here are the 10 most common Terraform commands in the AWS CLI to help you navigate and use the powerful tool and started with Terraform.

So if you’ve got your Terraform binary installed and you’re ready to rock and roll, now’s a good time to familiarize yourself with the Terraform commands you’ll use most.

When you need a quick reference guide, you can always pull up Terraform’s built-in command-line documentation. There are a couple of commands for doing that:

-   `terraform`
-   `terraform -h`
-   `terraform --help`

The resulting help page will have the main commands at the top, followed by the less common or more complex commands below.

![](https://res.cloudinary.com/acloud-guru/image/fetch/c_thumb,f_auto,q_auto/https://acg-wordpress-content-production.s3.us-west-2.amazonaws.com/app/uploads/2021/10/Terraform-screenshot.png){: .shadow }

You can also enter the terraform command and then a subcommand with `-h` or `--help` to pull up a list of commands that are specific to that subcommand. Let’s do a walkthrough of the 10 Terraform commands you may end up using the most.

**1\. `fmt`**  
When I’ve finished my Terraform configuration, I want to make sure that everything is formatted correctly, so I run the `fmt` command first. This command reformats your configuration in the standard style, so it’ll make sure that the spacing and everything else is formatted correctly. If it comes back blank, that means the configuration files within your working directory are already correctly formatted. If it does format a file, it will let you know what file it touched.

**2\. `init`**  
After you use the `format` command, you’ll want to initialize your working directory to prepare it for what you need. The `init` command looks at your configuration files and determines which providers and modules it needs to pull down from the registry to allow your configuration to work properly.

**3\. `validate`**  
Once you’ve initialized the directory, it’s good to run the`validate` command before you run `plan` or `apply`. Validation will catch syntax errors, version errors, and other issues. One thing to note here is that you can’t run `validate` before you run the `init` command. You have to initialize the working directory before you can run the validation.

**4\. `plan`**  
Next, it’s always a good idea to do a dry run of your plan to see what it’s actually going to do. You can even use one of the subcommands with `terraform plan` to output your plan to apply it later.

**5\. `apply`**  
And then of course you have your `apply` command, which is one of the commands you’re going to use the most. This is the command that deploys or applies your configuration to a provider.

**6\. `destroy`**  
The `destroy` command, obviously, will destroy your infrastructure — or, when used with the `target` flag, individual resources within your infrastructure.

**7\. `output`**  
If you’ve put together a good output variable file, you can use the `output` command to make those defined outputs to display certain information. For example, if you’re deploying EC2 instances, you can output tag names, instance names, instance IDs, the IP of the instance, and so on. You can gather some really good information that makes it simple to look up later. And if you’re working as a team, people coming behind you can use the `output` command to figure things out and get up to speed.

**8\. `show`**  
The `show` command shows the current state of a saved plan, providing good information about the infrastructure you’ve deployed. For example, if you have an EC2 instance or a VM deployed in your configuration, it’ll show you the state that it’s in — if it’s up and ready or if it’s being terminated. It also provides useful information like IP addresses.

**9\. `state`**  
Another good way to check your work is to use the `state` command. If you use `state` and then the subcommand `list`, it’ll give you a consolidated list of the resources that are being managed by your configuration. If you are moving your Terraform instance, such as from a local instance to a remote backup, you would use the `state mv` command. And just like the `show` command, there’s a `state show` command that shows a resource in the state. You can also remove instances from a state by using the `state rm` command.

**10\. `version`**  
You’ll use the `version` command quite a bit to check your Terraform version, especially if you have any version conflicts. Sometimes providers work only with certain versions of Terraform, so if you’re defining those versions within your configuration, you’ll need to use the `version` command here and there.  

Those are some of the most popular Terraform commands. Keep in mind that `-h` is a very handy way to quickly look up commands when you’re not 100% sure how to use one or what it does, especially when you’re getting started. Take a look at it when you get a chance!

## Terraform Command Lines

**Terraform CLI tricks**

-   **`terraform -install-autocomplete`** #Setup tab auto-completion, requires logging back in

**Format and Validate Terraform code**

-   **`terraform fmt`** #format code per HCL canonical standard
-   **`terraform validate`** #validate code for syntax
-   **`terraform validate -backend=false`** #validate code skip backend validation

**Initialize your Terraform working directory**

-   **`terraform init`** #initialize directory, pull down providers
-   **`terraform init -get-plugins=false`** #initialize directory, do not download plugins
-   **`terraform init -verify-plugins=false`** #initialize directory, do not verify plugins for Hashicorp signature

**Plan, Deploy and Cleanup Infrastructure**

-   **`terraform apply --auto-approve`** #apply changes without being prompted to enter “yes”
-   **`terraform destroy --auto-approve`** #destroy/cleanup deployment without being prompted for “yes”
-   **`terraform plan -out plan.out`** #output the deployment plan to plan.out
-   **`terraform apply plan.out`** #use the plan.out plan file to deploy infrastructure
-   **`terraform plan -destroy`** #outputs a destroy plan
-   **`terraform apply -target=aws_instance.my_ec2`** #only apply/deploy changes to the targeted resource
-   **`terraform apply -var my_region_variable=us-east-1`** #pass a variable via command-line while applying a configuration
-   **`terraform apply -lock=true`** #lock the state file so it can’t be modified by any other Terraform apply or modification action(possible only where backend allows locking)
-   **`terraform apply refresh=false`** # do not reconcile state file with real-world resources(helpful with large complex deployments for saving deployment time)
-   **`terraform apply --parallelism=5`** #number of simultaneous resource operations
-   **`terraform refresh`** #reconcile the state in Terraform state file with real-world resources
-   **`terraform providers`** #get information about providers used in current configuration

**Terraform Workspaces**

-   **`terraform workspace new mynewworkspace`** #create a new workspace
-   **`terraform workspace select default`** #change to the selected workspace
-   **`terraform workspace list`** #list out all workspaces

**Terraform State Manipulation**

-   **`terraform state show aws_instance.my_ec2`** #show details stored in Terraform state for the resource
-   **`terraform state pull > terraform.tfstate`** #download and output terraform state to a file
-   **`terraform state mv aws_iam_role.my_ssm_role module.custom_module`** #move a resource tracked via state to different module
-   **`terraform state replace-provider hashicorp/aws registry.custom.com/aws`** #replace an existing provider with another
-   **`terraform state list`** #list out all the resources tracked via the current state file
-   **`terraform state rm  aws_instance.myinstace`** #unmanage a resource, delete it from Terraform state file

**Terraform Import And Outputs**

-   **`terraform import aws_instance.new_ec2_instance i-abcd1234`** #import EC2 instance with id i-abcd1234 into the Terraform resource named “new\_ec2\_instance” of type “aws\_instance”
-   **`terraform import 'aws_instance.new_ec2_instance[0]' i-abcd1234`** #same as above, imports a real-world resource into an instance of Terraform resource
-   **`terraform output`** #list all outputs as stated in code
-   **`terraform output instance_public_ip`** # list out a specific declared output
-   **`terraform output -json`** #list all outputs in JSON format

**Terraform Miscelleneous commands**

-   **`terraform version`** #display Terraform binary version, also warns if version is old
-   **`terraform get -update=true`** #download and update modules in the “root” module.

**Terraform Console(Test out Terraform interpolations)**

-   **`echo 'join(",",["foo","bar"])' | terraform console`** #echo an expression into terraform console and see its expected result as output
-   **`echo '1 + 5' | terraform console`** #Terraform console also has an interactive CLI just enter “terraform console”
-   **`echo "aws_instance.my_ec2.public_ip" | terraform console`** #display the Public IP against the “my\_ec2” Terraform resource as seen in the Terraform state file

**Terraform Graph(Dependency Graphing)**

-   **`terraform graph | dot -Tpng > graph.png`** #produce a PNG diagrams showing relationship and dependencies between Terraform resource in your configuration/code

**Terraform Taint/Untaint(mark/unmark resource for recreation -> delete and then recreate)**

-   **`terraform taint aws_instance.my_ec2`** #taints resource to be recreated on next apply
-   **`terraform untaint aws_instance.my_ec2`** #Remove taint from a resource
-   **`terraform force-unlock LOCK_ID`** #forcefully unlock a locked state file, LOCK\_ID provided when locking the State file beforehand

**Terraform Cloud**

-   **`terraform login`** #obtain and save API token for Terraform cloud
-   **`terraform logout`** #Log out of Terraform Cloud, defaults to hostname app.terraform.io
