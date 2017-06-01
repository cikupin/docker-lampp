FROM ubuntu:15.10
LABEL maintainer="cikupin@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y dialog libterm-readline-perl-perl htop nano
RUN apt-get install -y autoconf gcc g++ make openssl libssl-dev libcurl4-openssl-dev pkg-config libsasl2-dev libpcre3-dev

RUN sed -i "s/^exit 101$/exit 0/" /usr/sbin/policy-rc.d

# Install apache2
RUN apt-get -y install apache2

# Clean .deb files
RUN apt-get clean

EXPOSE 80
WORKDIR "/var/www/html"
