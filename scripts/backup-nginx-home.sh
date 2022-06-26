#!/bin/bash

cd /var/www
tar zcf /root/nginx_backups/html-`date +%Y%m%d`.tar.gz html
