#!/bin/bash

mysqldump -u root -p guntantin > /root/mysql_backups
tar zcf /root/mysql_backups-`date +%Y%m%d`.tar.gz mysql
