FROM ubuntu:16.04
MAINTAINER Scott Collier <scott@onlinespaces.com>

ARG PROJECT_NAME
ARG XDEBUG_IDE_KEY
ARG XDEBUG_REMOTE_PORT
ARG XDEBUG_REMOTE_CONNECT_BACK
ARG TIME_ZONE
ARG PHP_FPM_PORT
ARG IP_ADDRESS
ARG USER_EMAIL
ARG USER_NAME

RUN apt-get clean && apt-get update && apt-get install -y \
    mysql-client \
    git \
    openssl \
    nano \
    openssh-server \
    supervisor \
    curl

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/apt/archives/*

# SSH Server - This is needed for windows development because
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
RUN mkdir -p /var/log/supervisor

#languages
RUN apt-get update &&\
    apt-get install language-pack-en -y &&\
    apt-get install -y python-software-properties software-properties-common && \
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

RUN apt-get clean && apt-get update -y && \
    apt-get install -y \
    php7.1 \
    php7.1-bcmath \
    php7.1-cli \
    php7.1-common \
    php7.1-curl \
    php7.1-dev \
    php7.1-fpm \
    php7.1-gd \
    php7.1-intl \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-mysql \
    php7.1-opcache \
    php7.1-soap \
    php7.1-xdebug \
    php7.1-xml \
    php7.1-zip

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/apt/archives/*

# Install PHPUnit
RUN wget https://phar.phpunit.de/phpunit.phar &&\
    chmod +x phpunit.phar &&\
    mv phpunit.phar /usr/local/bin/phpunit

#USER root
# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
COPY 00-opcache.ini /usr/local/etc/php/conf.d/
COPY 00-xdebug.ini /usr/local/etc/php/conf.d/
COPY .gitconfig /root/
COPY .bashrc /root/
COPY supervisord.conf /etc/supervisor/conf.d/

RUN sed -i -e "s/listen = \/run\/php\/php7.1-fpm.sock/listen = 0.0.0.0:${PHP_FPM_PORT}/g" /etc/php/7.1/fpm/pool.d/www.conf \
    && sed -i -e "s/;daemonize = yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf

# Change php fpm port
RUN sed -i "s/#XDEBUG_IDE_KEY#/${XDEBUG_IDE_KEY}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#XDEBUG_REMOTE_PORT#/${XDEBUG_REMOTE_PORT}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#XDEBUG_REMOTE_CONNECT_BACK#/${XDEBUG_REMOTE_CONNECT_BACK}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#PROJECT_NAME#/${PROJECT_NAME}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#IP_ADDRESS#/${IP_ADDRESS}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#PHP_FPM_PORT#/${PHP_FPM_PORT}/g" /etc/supervisor/conf.d/supervisord.conf && \
    sed -i "s/#USER_EMAIL#/${USER_EMAIL}/g" /root/.gitconfig && \
    sed -i "s/#USER_NAME#/${USER_NAME}/g" /root/.gitconfig

# Show git information in the prompt. For more info see https://github.com/magicmonty/bash-git-prompt
RUN git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1

RUN mkdir -p /run/php && chmod 777 /run/php

# Set timezone
RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    "date"

# Yarn
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - &&\
    apt-get install -y nodejs

# Yarn
RUN curl -Ss https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
        php composer-setup.php && \
        php -r "unlink('composer-setup.php');" && \
        # Install webpack
        npm install --global webpack && \
        # Install Bower
        npm install -g bower && \
        # Install Gulp
        npm install -g gulp-cli

EXPOSE 22
EXPOSE 9000
WORKDIR /var/www/${PROJECT_NAME}

CMD ["/usr/bin/supervisord"]


