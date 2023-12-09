---
title: Linux Backups
date: 2021-02-01 12:00:00
categories: [Linux, Basics]
tags: [linux, backups]
---
<script defer data-domain="senad-d.github.io" src="https://plus.seki.ink/js/script.js"></script>

![](https://github.com/senad-d/senad-d.github.io/blob/main/_media/images/linux-banner.png?raw=true){: .shadow }

## Backup-daily
```shell
cat <<EOF >> /home/"$USER"/backup-task/backup-daily.sh
#!/bin/bash
tar --exclude=<path to ignore file> -zcf /home/"$USER"/backup/daily/backup-\$(date +%Y%m%d).tar.gz -C /home/"$USER"/<BackupFolder>/*
find /home/"$USER"/backup/daily/* -mtime +7 -delete
EOF
chmod +x /home/"$USER"/backup-task/backup-daily.sh
```

## Backup-weekly
```shell
cat <<EOF >> /home/"$USER"/backup-task/backup-weekly.sh
#!/bin/bash
tar --exclude=<ignore file> -zcf /home/"$USER"/backup/weekly/backup-\$(date +%Y%m%d).tar.gz -C /home/"$USER"/<BackupFolder>/*
find /home/"$USER"/backup/weekly/* -mtime +31 -delete
EOF
chmod +x /home/"$USER"/backup-task/backup-weekly.sh
```

## Backup-monthly
```shell
cat <<EOF >> /home/"$USER"/backup-task/backup-monthly.sh
#!/bin/bash
tar --exclude=<ignore file> -zcf /home/"$USER"/backup/monthly/backup-\$(date +%Y%m%d).tar.gz -C /home/"$USER"/<BackupFolder>/*
find /home/"$USER"/backup/monthly/* -mtime +365 -delete
EOF
chmod +x /home/"$USER"/backup-task/backup-monthly.sh
```

## Add Chrontab task
```shell
cat <<EOF >> /etc/cron.d/crontask 
30 5 * * * root    /home/"$USER"/backup-task/backup-daily.sh 
40 5 * * 1 root    /home/"$USER"/backup-task/backup-weekly.sh 
50 5 1 * * root    /home/"$USER"/backup-task/backup-monthly.sh 
EOF 
crontab -u "$USER" /etc/cron.d/crontask
```