FROM php:5.6.39-apache-jessie
LABEL maintainer="cikupin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y snmp wget
RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install latest git
RUN apt-get install -y git

# Install Datadog PHP APM tracer (beta 0.8.1)
RUN wget -O datadog-php-tracer.deb https://github.com/DataDog/dd-trace-php/releases/download/0.8.1/datadog-php-tracer_0.8.1-beta_amd64.deb
RUN dpkg -i datadog-php-tracer.deb
RUN rm -f datadog-php-tracer.deb

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
        libxslt-dev \
        libmagickwand-dev --no-install-recommends

# Install PHP extension
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) tidy
RUN docker-php-ext-install -j$(nproc) mcrypt
RUN docker-php-ext-install -j$(nproc) pspell
RUN docker-php-ext-install -j$(nproc) recode
RUN docker-php-ext-install -j$(nproc) snmp
RUN docker-php-ext-install -j$(nproc) xmlrpc
RUN docker-php-ext-install -j$(nproc) xsl
RUN docker-php-ext-install -j$(nproc) bcmath
RUN docker-php-ext-install -j$(nproc) bz2
RUN docker-php-ext-install -j$(nproc) calendar
RUN docker-php-ext-install -j$(nproc) dba
RUN docker-php-ext-install -j$(nproc) exif
RUN docker-php-ext-install -j$(nproc) gettext
RUN docker-php-ext-install -j$(nproc) mysql
RUN docker-php-ext-install -j$(nproc) mysqli
RUN docker-php-ext-install -j$(nproc) pcntl
RUN docker-php-ext-install -j$(nproc) pdo_mysql
RUN docker-php-ext-install -j$(nproc) pdo_pgsql
RUN docker-php-ext-install -j$(nproc) soap
RUN docker-php-ext-install -j$(nproc) sockets
RUN docker-php-ext-install -j$(nproc) sysvmsg
RUN docker-php-ext-install -j$(nproc) sysvsem
RUN docker-php-ext-install -j$(nproc) sysvshm
RUN docker-php-ext-install -j$(nproc) wddx
RUN docker-php-ext-install -j$(nproc) shmop
RUN docker-php-ext-install -j$(nproc) zip

RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install -j$(nproc) imap

RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install -j$(nproc) pgsql

RUN pecl install mongo
RUN pecl install intl
RUN pecl install imagick
RUN pecl install rdkafka
RUN pecl install mongodb
RUN pecl install memcache
RUN pecl install ps-1.3.7
RUN pecl install apcu-4.0.11

# Enable PECL extensions
RUN docker-php-ext-enable mongo intl imagick rdkafka mongodb memcache ps apcu

# Use the default production configuration
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Enable Authorization header in apache
RUN echo "SetEnvIf Authorization \"(.*)\" HTTP_AUTHORIZATION=\$1" >> /etc/apache2/apache2.conf

# Enable apache2 modules
RUN a2enmod rewrite

# Install original composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN mv composer.phar /usr/local/bin/composer
RUN php -r "unlink('composer-setup.php');"

# Clean files
RUN apt-get autoclean
RUN apt-get clean
RUN apt-get autoremove
RUN rm -rf /tmp/*

WORKDIR /var/www/html
