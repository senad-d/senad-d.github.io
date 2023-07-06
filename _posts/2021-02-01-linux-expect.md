---
title: Linux expect Command
date: 2021-02-01 12:00:00
categories: [OS, Linux]
tags: [linux, expect]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }

System administrators automate repetitive tasks all the time. Bash scripts provide many programs and features to carry out system automation tasks. The expect command offers a way to control interactive applications which require user input to continue.

## Linux expect Command Syntax

The **`expect`** command runs Expect program scripts using the following syntax:

```shell
expect [options] [commands/command file]
```

The Except program uses the following keywords to interact with other programs:

| Command | Function |
| --- | --- |
| **`spawn`** | Creates a new process. |
| **`send`** | Sends a reply to the program. |
| **`expect`** | Waits for output. |
| **`interact`** | Enables interacting with the program. |

Expect uses TCL (Tool Command Language) to control the program flow and essential interactions.

Some systems do not include Expect by default.

To install it with **`apt`** on Debian-based systems, run the following in the terminal:

```shell
sudo apt install expect
```

Alternatively, use **`yum`** on Red Hat\-based systems:

```shell
yum install expect
```

Follow the installation instructions to complete the setup.

### Linux expect Command Options

Below is a table describing available command options for the **`expect`** command:

| Command | Description |
| --- | --- |
| **`-c`** | Specifies the command to execute before the script. |
| **`-d`** | Provides a brief diagnostic output. |
| **`-D`** | Interactive debugger. |
| **`-f`** | Specifies a file to read from. |
| **`-i`** | Prompts commands interactively. |
| **`-b`** | Reads file line by line (buffer). |
| **`-v`** | Print version. |

## Linux expect Command Examples

The next sections provide practical examples of the **`expect`** command, which executes Expect program scripts. To make an Expect script executable, add the following shebang at the start of each script:

```shell
#!/usr/bin/expect
```

The location differs depending on the system. To find the exact path, use:

```shell
whereis expect
```

Exchange the location if Expect is at a different location.

### Autoexpect

Instead of writing Expect scripts from scratch, the Autoexpect program helps generate scripts interactively.

To demonstrate how Autoexpect works, do the following:

1\. Run the Bash script from the first example (_interactive\_script.sh_) using Autoexpect:

```shell
autoexpect ./interactive_script.sh
```
The output prints a confirmation message and the Expect script name (_script.exp_) to the console.

2\. Provide answers to the questions. The replies save to the _script.exp_ file and generate the Expect program code automatically. When complete, the output prints a confirmation.

3\. Review the generated script in a text editor to see the code:

```shell
vim script.exp
```

The interactions are saved to the Expect script for future use.

Conclusion

After following the steps from this guide, you know the purpose of Expect scripts, the **`expect`** command, and some use cases.

Expect is a powerful automation tool for system administration tasks and code testing. Use the man command to review the complete manual for Expect.

### Basic Expect Use

Below is a basic example that explains how the **`expect`** command functions:

1\. Open a text editor and name the file _interactive\_script.sh_. If you use Vim, run:

```shell
vim interactive_script.sh
```

2\. Add the following code to the file:

```shell
#!/bin/bash

echo "Hello, who is this?"
read $REPLY
echo "What's your favorite color?"
read $REPLY
echo "How many cats do you have?"
read $REPLY
```

The code is a basic script with the read command that expects user interaction when run.

3\. Save the file and close Vim:

```shell
:wq
```

4\. Change the script to executable:

```shell
chmod +x interactive_script.sh
```

5\. Create a new file to store the Expect script with:

```shell
vim expect_response.exp
```

The _.exp_ extension is not mandatory, though it helps differentiate Expect scripts from other files.

6\. Add the following code to the script:

```shell
#!/usr/bin/expect

spawn ./interactive_script.sh
expect "Hello, who is this?\r"
send -- "phoenixNAP\r"
expect "What's your favorite color?\r"
send -- "Blue\r"
expect "How many cats do you have?\r"
send -- "1\r"
expect eof
```

The script consists of the following lines:

-   **`spawn`** creates a new process running the _interactive\_script.sh_ file.
-   **`expect`** writes the expected program message and waits for the output. The final line ends the program.
-   **`send`** contains the replies to the program after each expected message.

7\. Save the file and close:

```shell
:wq
```

8\. Make the script executable:

```shell
chmod +x expect_response.exp
```

9\. Run the script with:

```shell
expect expect_response.exp
```

Or alternatively:

```shell
./expect_response.exp
```

The expect_response.exp script spawns the program process and sends automatic replies.

### Examples

Create certificates with Easy-RSA for OpenVPN

When utilizing scripts that require data input during execution, such as Easy-RSA, which prompts you to enter data into multiple fields with different information, you can employ the following command:

```shell
CMD="/etc/easy-rsa/easyrsa build-ca nopass"
expect << EOF
spawn $CMD
expect -exact "\r
Enter PEM pass phrase:"
send -- "<example>\r"
expect -exact "\r
Verifying - Enter PEM pass phrase:"
send -- "<example>\r"
expect -exact "\r
Common Name (eg: your user, host, or server name) \[Easy-RSA CA\]:"
send -- "<Name>\r"
expect eof
EOF
```