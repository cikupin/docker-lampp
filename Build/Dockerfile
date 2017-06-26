FROM ubuntu:15.10
LABEL maintainer="cikupin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y dialog libterm-readline-perl-perl htop nano
RUN apt-get install -y autoconf gcc g++ make openssl libssl-dev \
    libcurl4-openssl-dev pkg-config libsasl2-dev libpcre3-dev snmp

RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install apache2
RUN apt-get -y install apache2

# Install PHP
RUN apt-get -y install php5 libapache2-mod-php5 php5-dev php5-mysqlnd php5-curl php5-gd \
    php5-intl php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-ming php5-apcu \
    php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-pgsql
RUN pecl install mongo
RUN pecl install mongodb

# Install phalcon framework
RUN curl -s "https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh" | bash
RUN apt-get install php5-phalcon

# Enable php modules
RUN php5enmod mcrypt
RUN a2enmod rewrite

# Install PhpMyAdmin
RUN apt-get -y install phpmyadmin

# Clean .deb files
RUN apt-get autoclean
RUN apt-get clean
RUN apt-get autoremove
RUN rm -rf /tmp/*

EXPOSE 80
WORKDIR "/var/www/html"
