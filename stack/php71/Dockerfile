FROM php:7.1.7-fpm
LABEL maintainer Bert Oost <hello@bertoost.com>

# Create docker PHP user.
RUN adduser \
   -u 1000 \
   --system \
   --shell /bin/bash \
   --group \
   --disabled-password \
   php
RUN mkdir -p /var/www/html
RUN chown php:php /var/www/html

# SSMTP config.
COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

# Install modules
RUN apt-get update \
    && apt-get install -y \
        wget \
        build-essential \
        nano \
        vim \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        imagemagick \
        git \
        locales \
        libssl-dev \
        re2c \
        libmcrypt-dev \
        zip \
        unzip \
        libicu52 \
        libmagickwand-6.q16-dev --no-install-recommends \
        libicu-dev \
        g++ \
        ssmtp \
        libyaml-dev \
        gettext \
        openssh-client \
        pdftk \
        libldap2-dev \
        apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

#install MSSQL (ODBC) driver
# Add Microsoft repo for Microsoft ODBC Driver 13 for Linux
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update

RUN ACCEPT_EULA=Y apt-get install -y \
    unixodbc \
    unixodbc-dev \
    libgss3 \
    odbcinst \
    msodbcsql \
    locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen


RUN ln -fs /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install \
        iconv \
        mcrypt \
        gd \
        pdo \
        pdo_mysql \
        mysqli \
        mbstring \
        soap \
        sysvmsg \
        sysvshm \
        sysvsem \
        intl \
        opcache \
        pcntl \
        shmop \
        zip \
        gettext \
        sockets \
        exif \
        ldap

RUN echo 'en_US ISO-8859-1\n\
    en_US.ISO-8859-15 ISO-8859-15\n\
    en_US.UTF-8 UTF-8\n\
    nl_NL ISO-8859-1\n\
    nl_NL.UTF-8 UTF-8\n\
    nl_NL@euro ISO-8859-15\n'\
    >> /etc/locale.gen && /usr/sbin/locale-gen

RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin/

RUN		wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.13.tar.gz --output-document=/tmp/libsodium.tar.gz \
		&& cd /tmp \
		&& tar -xzvf libsodium.tar.gz \
		&& cd libsodium-1.0.13 \
		&& ./configure \
		&& make && make check && make install \
		&& rm -rf /tmp/libsodium*

RUN pecl install \
    xdebug \
    yaml-2.0.0 \
    imagick \
    libsodium \
    sqlsrv \
    pdo_sqlsrv \
    APCu

RUN echo "extension=yaml.so" > /usr/local/etc/php/conf.d/pecl-yaml.ini \
    && echo "extension=imagick.so" > /usr/local/etc/php/conf.d/pecl-imagck.ini \
    && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/pecl-apcu.ini \
    && echo "extension=sodium.so" > /usr/local/etc/php/conf.d/pecl-sodium.ini \
    && echo "extension=sqlsrv.so" > /usr/local/etc/php/conf.d/sqlsrv.ini \
    && echo "extension=pdo_sqlsrv.so" >> /usr/local/etc/php/conf.d/sqlsrv.ini

# Download and add-in BlackFire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp \
    && mv /tmp/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so

# Xdebug config.
COPY conf.d/pecl-xdebug.ini /usr/local/etc/php/conf.d/pecl-xdebug.ini

# Blackfire integration
COPY conf.d/blackfire.ini /usr/local/etc/php/conf.d/backfire.ini

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer.phar

# Remove temporary stuff
RUN apt-get purge -y --auto-remove \
    libicu-dev \
    g++

# Add composer and php scripts for aliases.
COPY home/ /home/php/
RUN chmod +x /home/php/composer.sh && chmod +x /home/php/php.sh

# php.ini
COPY conf.d/php.ini /usr/local/etc/php/conf.d/php.ini

# Run commands inside this container as the created PHP user.
USER php

CMD ["php-fpm"]
