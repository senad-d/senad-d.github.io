---
title: Linux Alias
date: 2021-02-01 12:00:00
categories: [OS, Linux]
tags: [linux, alias]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }

List All Aliases in Linux
```shell
alias
```

Create a Temporary Alias in Linux
```shell
alias c='clear'
```
 
Create a Permanent Alias in Linux
```shell
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

Remove Aliases in Linux
```shell
unalias [name]
```