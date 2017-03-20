FROM php:7.1-fpm
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

ENV TERM xterm

RUN export TERM=xterm && \
    apt-get clean && apt-get update && apt-get install -y \
    apt-utils \
    apt-transport-https \
    ca-certificates \
    ctags \
    indent \
    curl \
    imagemagick \
    graphicsmagick \
    mysql-client \
    git \
    bzip2 \
    gzip \
    unzip \
    zip \
    openssl \
    zlib1g-dev \
    libicu-dev \
    libpq-dev \
    libpng12-dev \
    libgd-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmemcached-dev \
    libmcrypt-dev \
    libldap2-dev \
    nano \
    net-tools \
    openssh-client \
    openssh-server \
    ruby-full \
    supervisor \
    vim \
    vim-addon-manager \
    vim-vimoutliner \
    vim-doc \
    wget \
    xz-utils

# Yarn
RUN curl -Ss https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \

    apt-get update && apt-get install -y yarn && \

    # Set timezone
    rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime && \
    "date"

# PHP
RUN pecl install xdebug zip && \
    docker-php-ext-install mcrypt opcache intl pdo pdo_mysql exif iconv && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-enable opcache mcrypt xdebug zip exif && \

    mkdir -p /var/log/supervisor && \

    # Show git information in the prompt. For more info see https://github.com/magicmonty/bash-git-prompt
    git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1 && \

    # Node
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \

    # NVM
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash && \

    # Disable progress bars by default: https://github.com/npm/npm/issues/11283
    bash -l -c "npm set progress=false" && \

    # Install Compass
    gem update --system && gem install compass && \

    # Install Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --version && \

    # Install PHPUnit
    curl -sSL https://phar.phpunit.de/phpunit.phar -o phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \

    # Install Drush
    php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > /usr/local/bin/drush && \
    chmod +x /usr/local/bin/drush && \

    # Install Drupal Console
    curl https://drupalconsole.com/installer -o /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal && \

    # Add default drush aliases
    mkdir -p /etc/drush/site-aliases && \

    # Install Bower
    npm install -g bower && \

    # Install Gulp
    npm install -g gulp-cli && \

    # Install Grunt
    npm install -g grunt-cli && \

    # Symfony Executable
    curl -LsS https://symfony.com/installer -o /usr/local/bin/symfony && \
    chmod a+x /usr/local/bin/symfony && \

    # SSH - Because docker does not work interactively on windows
    mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \

    # SSH login fix. Otherwise user is kicked off after login
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

COPY default.aliases.drushrc.php /etc/drush/site-aliases/

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

#USER www-data
#RUN composer global require hirak/prestissimo:^0.3 --optimize-autoloader && \
#    rm -rf ~/.composer/.cache && \
#    drupal init --override

#USER root
# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
COPY 00-opcache.ini /usr/local/etc/php/conf.d/
COPY 00-xdebug.ini /usr/local/etc/php/conf.d/
COPY .gitconfig /root/
COPY .bashrc /root/
COPY supervisord.conf /etc/supervisor/conf.d/

# Change php fpm port
RUN sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${PHP_FPM_PORT}/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${PHP_FPM_PORT}/g" /usr/local/etc/php-fpm.d/www.conf.default && \
    sed -i "s/#XDEBUG_IDE_KEY#/${XDEBUG_IDE_KEY}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#XDEBUG_REMOTE_PORT#/${XDEBUG_REMOTE_PORT}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#XDEBUG_REMOTE_CONNECT_BACK#/${XDEBUG_REMOTE_CONNECT_BACK}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#PROJECT_NAME#/${PROJECT_NAME}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#IP_ADDRESS#/${IP_ADDRESS}/g" /usr/local/etc/php/conf.d/00-xdebug.ini && \
    sed -i "s/#PHP_FPM_PORT#/${PHP_FPM_PORT}/g" /etc/supervisor/conf.d/supervisord.conf && \
    sed -i "s/#USER_EMAIL#/${USER_EMAIL}/g" /root/.gitconfig && \
    sed -i "s/#USER_NAME#/${USER_NAME}/g" /root/.gitconfig

EXPOSE 22
WORKDIR /var/www/${PROJECT_NAME}

CMD ["/usr/bin/supervisord"]


