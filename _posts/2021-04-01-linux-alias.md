---
title: Alias
date: 2021-04-01 12:00:00
categories: [OS, Linux]
tags: [linux, alias]
---
![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true)

Create a Temporary Alias in Linux
```Bash
alias c='clear'
```
 
Create a Permanent Alias in Linux
```Bash
sudo nano ~/.bashrc
source ~/.bashrc

sudo nano ~/.zshrc
source ~/.zshrc
```
 
Custom aliases
```shell
alias c='clear'
alias move='mv -i'
alias frename='Example/Test/file_rename.sh'

source ~/.bashrc
```

List All Aliases in Linux
```shell
alias
```

Remove Aliases in Linux
```shell
unalias [name]
```