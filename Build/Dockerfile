FROM php:5.6.39-apache-jessie
LABEL maintainer="cikupin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y dialog libterm-readline-perl-perl htop nano
RUN apt-get install -y autoconf gcc g++ make openssl libssl-dev \
    libcurl4-openssl-dev pkg-config libsasl2-dev libpcre3-dev snmp
RUN apt-get install -y software-properties-common

RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install latest git
RUN apt-get install -y git

# Install librdkafka c library
RUN mkdir -p /tmp/librdkafka
WORKDIR /tmp/librdkafka
RUN git clone https://github.com/edenhill/librdkafka.git .
RUN ./configure
RUN make
RUN make install
WORKDIR /
RUN rm -rf /tmp/librdkafka

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libtidy-dev \
        libpq-dev \
        libc-client-dev \
        libkrb5-dev \
        libmcrypt-dev \
        libreadline-dev \
        libpspell-dev \
        librecode-dev \
        libxml2-dev \
        libsnmp-dev \
        libicu-dev \
        pslib1 pslib-dev \
        libmagickwand-dev --no-install-recommends

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) tidy
RUN docker-php-ext-install -j$(nproc) mcrypt
RUN docker-php-ext-install -j$(nproc) pspell
RUN docker-php-ext-install -j$(nproc) recode
RUN docker-php-ext-install -j$(nproc) snmp
RUN docker-php-ext-install -j$(nproc) xmlrpc

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install -j$(nproc) imap

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install -j$(nproc) pgsql

# RUN docker-php-ext-install -j$(nproc) ming
# RUN docker-php-ext-install -j$(nproc) apcu
# RUN docker-php-ext-install -j$(nproc) xls

# error: /usr/src/php/ext/pear does not exist
# usage: /usr/local/bin/docker-php-ext-install [-jN] ext-name [ext-name ...]
#    ie: /usr/local/bin/docker-php-ext-install gd mysqli
#        /usr/local/bin/docker-php-ext-install pdo pdo_mysql
#        /usr/local/bin/docker-php-ext-install -j5 gd mbstring mysqli pdo pdo_mysql shmop
# if custom ./configure arguments are necessary, see docker-php-ext-configure
# Possible values for ext-name:
# bcmath bz2 calendar ctype curl dba dom enchant exif fileinfo filter ftp gd gettext gmp hash iconv imap interbase intl json ldap mbstring mcrypt mssql mysql mysqli oci8 odbc opcache pcntlpdo pdo_dblib pdo_firebird pdo_mysql pdo_oci pdo_odbc pdo_pgsql pdo_sqlite pgsql phar posix pspell readline recode reflection session shmop simplexml snmp soap sockets spl standard sybase_ct sysvmsg sysvsem sysvshm tidy tokenizer wddx xml xmlreader xmlrpc xmlwriter xsl zip

# configure: error: not found. Please provide a path to MagickWand-config or Wand-config program.
# ERROR: `/tmp/pear/temp/imagick/configure --with-php-config=/usr/local/bin/php-config --with-imagick` failed

RUN pecl install mongo
RUN pecl install intl
RUN pecl install imagick
RUN pecl install rdkafka
RUN pecl install mongodb
RUN pecl install memcache
RUN pecl install ps-1.3.7

RUN docker-php-ext-enable mongo intl imagick rdkafka mongodb memcache ps

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
