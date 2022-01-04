FROM php:7.4.27-apache

WORKDIR /var/www/html

# set up le repo
RUN apt update && apt install -y git libzip-dev libbz2-dev libedit-dev
RUN git clone https://github.com/cydrobolt/polr.git --depth=1

# set up les permissions
RUN chmod -R 755 polr && chown -R www-data polr

COPY apache2.conf /etc/apache2/sites-available/000-default.conf

# set up php
RUN docker-php-ext-install \
    zip \
    bz2 \
    pdo \
    pdo_mysql \
    json \
    opcache

WORKDIR /var/www/html/polr

RUN curl -sS https://getcomposer.org/installer | php
RUN php composer.phar install --no-dev -o

RUN a2enmod rewrite

RUN cp .env.setup .env

WORKDIR /var/www/html

# set up les permissions
RUN chmod -R 755 polr && chown -R www-data polr

EXPOSE 80