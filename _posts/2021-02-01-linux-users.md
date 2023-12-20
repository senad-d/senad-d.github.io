---
title: Linux Users
date: 2021-02-01 12:00:00
categories: [Linux, Linux Basics]
tags: [linux, users]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.pro/js/script.js"></script>
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }


`sudo adduser username` | Create a new user

`sudo userdel username` | Delete a user

`sudo usermod -aG groupname username` | Add a user to group

`sudo deluser username groupname` | Remove a user from a group


## Create multiple users ( it requires a separate list for user names and keys )

create_user.sh
```shell
#!/bin/bash
​
version=$(cat /etc/os-release | head -1)
number=0
​
for user in $(cat ${1} | awk '{print $1}'); do
    ((number+=1))
    key=$(cat ${1} | sed $number'q;d' | awk '{print $2 " " $3 " " $4}')
        # This is for Linux-instances
        if [ "$version" = 'NAME="Amazon Linux"' ];then
        adduser $user
        mkdir /home/$user/.ssh
        echo $key > /home/$user/.ssh/authorized_keys
        chown -R $user:$user /home/$user/.ssh
        chmod 700 /home/$user/.ssh
        chmod 600 /home/$user/.ssh/authorized_keys
        fi
        # This is for ubuntu-instances
        if [ "$version" = 'NAME="Ubuntu"' ];then
        adduser --disabled-password --gecos "" $user
        mkdir /home/$user/.ssh
        echo $key > /home/$user/.ssh/authorized_keys
        chown -R $user:$user /home/$user/.ssh
        chmod 700 /home/$user/.ssh
        chmod 600 /home/$user/.ssh/authorized_keys
        fi
    echo "Do you want to $user become sudo?"
    echo "Type yes or no"
    read sudo
        if [ "$sudo" = 'yes' ] || [ "$sudo" = 'no' ];then
            echo "You selected $sudo."
        else
            echo "You type incorrectly. Abort"
            exit 1
        fi
        if [ "$sudo" = 'yes' ];then
            echo
            # This is for Linux-instances
            if [ "$version" = 'NAME="Amazon Linux"' ];then
            usermod -aG wheel $user
            sudoers=$(tail -1 /etc/sudoers)
                if [ "$sudoers" = '#includedir /etc/sudoers.d' ] || [ "$sudoers" = 'Defaults env_keep += "SSH_CLIENT"' ];then
                sudo sh -c "echo \"%wheel  ALL=(ALL)   NOPASSWD:  ALL\" >> /etc/sudoers"
                fi
            fi
            # This is for ubuntu-instances
            if [ "$version" = 'NAME="Ubuntu"' ];then
            usermod -aG sudo $user
            sudoers=$(tail -1 /etc/sudoers)
                if [ "$sudoers" = '#includedir /etc/sudoers.d' ] || [ "$sudoers" = 'Defaults env_keep += "SSH_CLIENT"' ];then
                sudo sh -c "echo \"%sudo  ALL=(ALL)   NOPASSWD:  ALL\" >> /etc/sudoers"
                fi
            fi
            echo "$user is now sudo"
            echo
        else
            echo "Skipping"
            echo
        fi
done
```
user_list
```shell

```