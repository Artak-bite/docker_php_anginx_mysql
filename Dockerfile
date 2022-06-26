FROM ubuntu:20.04
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Europe/Moscow apt-get -y install tzdata
RUN apt-get install -y \
    ssh \
    ufw \
    cron \
    nginx \
    iptables \
    mysql-server \
    php-fpm php-mysql \
    iptables-persistent \
    vim

WORKDIR /setup


#COPY start-services.sh start-services.sh
COPY ./scripts/prepare-nginx.sh prepare-nginx.sh
COPY nginx-conf nginx-conf
COPY index.php index.php
RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup
RUN cp nginx-conf /etc/nginx/sites-available/default
RUN sh prepare-nginx.sh


# Nginx home directory backup
RUN mkdir /var/nginx_backups
COPY ./scripts/backup-nginx-home.sh /root/
RUN chmod +x /root/backup-nginx-home.sh
RUN touch /etc/crontab && chmod 644 /etc/crontab
RUN echo "0 */6 * * *  tar -zcf FILES-backup/"$(date '+\%m-\%d-\%y').tar.gz" /var/www/html/" >> /etc/crontab

# Mysql backup
RUN mkdir /var/mysql_backups
COPY ./scripts/backup-mysql-home.sh /root/
RUN echo "0 1 * * *  mysqldump -u root -p guntantin DB > DB-backups/$(date +\%m-\%d-\%Y-\%H.\%M.\%S)-user-db.sql" >> /etc/crontab
RUN echo "0 10 * * * find FILES-backup/* -mtime +10 -type d -exec rm -r {} \; >/dev/null 2>&1" >> /etc/crontab
RUN service cron restart


COPY ./scripts/block_connection.sh block_connection.sh
RUN chmod +x block_connection.sh
RUN block_connection.sh

EXPOSE 80

ENTRYPOINT service php7.4-fpm start && \
           service nginx start && \
           service ssh restart && \
           ufw enable && \
           ufw default deny incoming && \
           ufw allow http && \
           ufw allow https && \
           bash
