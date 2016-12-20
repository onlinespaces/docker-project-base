FROM php:7.0-fpm
MAINTAINER Scott Collier <scott@onlinespaces.com>

ARG PROJECT_NAME
ARG XDEBUG_IDE_KEY
ARG XDEBUG_REMOTE_PORT
ARG TIME_ZONE
ARG PHP_FPM_PORT

ENV TERM xterm

RUN export TERM=xterm

RUN apt-get clean && apt-get update && apt-get install -y \
        apt-utils \
        imagemagick \
        graphicsmagick \
        git \
        bzip2 \
        unzip \
        xz-utils \
        curl \
        openssl \
        zip \
        zlib1g-dev \
        libicu-dev \
        libpq-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libldap2-dev \
        net-tools \
        openssh-server \
        supervisor \
        nano \
        vim \
        vim-addon-manager \
        vim-vimoutliner \
        vim-doc \
        ctags \
        indent

# PHP
RUN pecl install xdebug
RUN docker-php-ext-install mcrypt opcache intl pdo pdo_mysql
RUN docker-php-ext-enable opcache mcrypt xdebug

RUN mkdir -p /var/log/supervisor

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN { \
        echo 'zend_extension=xdebug.so'; \
        echo 'error_reporting = E_ALL'; \
        echo 'display_startup_errors = On'; \
        echo 'display_errors = On'; \
        echo 'xdebug.remote_enable = 1'; \
        echo 'xdebug.remote_connect_back = 1'; \
} > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN echo "xdebug.idekey = \"${XDEBUG_IDE_KEY}\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_port = ${XDEBUG_REMOTE_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Set timezone
RUN rm /etc/localtime
RUN ln -s ${TIME_ZONE} /etc/localtime
RUN "date"

# Change php fpm port
RUN sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${PHP_FPM_PORT}/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${PHP_FPM_PORT}/g" /usr/local/etc/php-fpm.d/www.conf.default

COPY .bashrc /root/

# Show git information in the prompt. For more info see https://github.com/magicmonty/bash-git-prompt
RUN git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1
RUN ["/bin/bash", "-c", "source /root/.bashrc"]

# Node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# NVM
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | sh -e

# Disable progress bars by default: https://github.com/npm/npm/issues/11283
RUN bash -l -c "npm set progress=false"

# Install Ruby.
# RUN apt-get update && apt-get install -y ruby-full

# Install Compass
# RUN gem update --system && gem install compass

# Install Composergit c
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer --version

# Install PHPUnit
curl -sSL https://phar.phpunit.de/phpunit.phar -o phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \

# Install drush
php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > /usr/local/bin/drush && \
chmod +x /usr/local/bin/drush && \

# Install Drupal Console
curl https://drupalconsole.com/installer -o /usr/local/bin/drupal && \
chmod +x /usr/local/bin/drupal && \

# Install Yarn
RUN npm install -g yarn

# Install Bower
RUN npm install -g bower

# Install Gulp
RUN npm install -g gulp-cli

# Install Grunt
RUN npm install -g grunt-cli

# Symfony Executable
RUN curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony
RUN chmod a+x /usr/local/bin/symfony

# SSH - Because docker does not work interactively on windows
RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

EXPOSE 22 ${PHP_FPM_PORT} ${XDEBUG_REMOTE_PORT}

WORKDIR /var/www/${PROJECT_NAME}

RUN git config --system user.email "${USER_EMAIL}"
RUN git config --system user.name "${USER_NAME}"

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN sed -i "s/#PHP_FPM_PORT#/${PHP_FPM_PORT}/g" /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]


