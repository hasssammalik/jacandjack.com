FROM php:5.6-apache


RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y net-tools curl php5-mcrypt php5-mysql php-apc php5-gd php5-xmlrpc php5-imap php5-curl \
    libc-client-dev libkrb5-dev libssl-dev unzip zip
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-install sockets
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng12-dev \
    libicu-dev \
    libxml2-dev \
    nano \
    wget \
    unzip \
    git \
    && docker-php-ext-install -j$(nproc) iconv intl xml soap mcrypt opcache pdo pdo_mysql mysqli mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos
RUN docker-php-ext-install imap


RUN a2enmod rewrite
RUN a2enmod ssl

ADD 000-default.conf /etc/apache2/sites-enabled/
ADD default-ssl.conf /etc/apache2/sites-enabled/
ADD src/ www-server/

EXPOSE 443