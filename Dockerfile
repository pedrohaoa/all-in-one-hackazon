FROM ubuntu:latest
MAINTAINER Chris Mutzel <chris.mutzel@gmail.com>
RUN apt-get update # Fri Oct 24 13:09:23 EDT 2014
RUN apt-get -y upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client mysql-server apache2 libapache2-mod-php5 pwgen python-setuptools vim-tiny php5-mysql  php5-ldap unzip
RUN easy_install supervisor
ADD ./scripts/start.sh /start.sh
ADD ./scripts/foreground.sh /etc/apache2/foreground.sh
ADD ./configs/supervisord.conf /etc/supervisord.conf
ADD ./configs/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN rm -rf /var/www/
ADD https://github.com/rapid7/hackazon/archive/master.zip /hackazon-master.zip
RUN unzip /hackazon-master.zip -d hackazon
RUN mv /hackazon/hackazon-master/ /var/www/hackazon
RUN chown -R www-data:www-data /var/www/
RUN chown -R www-data:www-data /var/www/hackazon/web/user_pictures/
RUN chown -R www-data:www-data /var/www/hackazon/web/upload
RUN chown -R www-data:www-data /var/www/hackazon/assets/config
RUN chmod 755 /start.sh
RUN chmod 755 /etc/apache2/foreground.sh
RUN a2enmod rewrite 
RUN mkdir /var/log/supervisor/
EXPOSE 80
CMD ["/bin/bash", "/start.sh"]
