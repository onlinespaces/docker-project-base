FROM php:5.6-fpm
MAINTAINER Scott Collier <scott@onlinespaces.com>

ARG PROJECT_NAME
ARG XDEBUG_IDE_KEY
ARG XDEBUG_REMOTE_PORT
ARG TIME_ZONE
ARG PHP_FPM_PORT

ENV TERM xterm

COPY .bashrc /root/
COPY supervisord.conf /etc/supervisor/conf.d/
COPY .gitconfig /root/

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
    "date" && \

    # PHP
    pecl install xdebug && \
    docker-php-ext-install mcrypt opcache intl pdo pdo_mysql gd && \
    docker-php-ext-enable opcache mcrypt xdebug && \

    mkdir -p /var/log/supervisor && \

    # Show git information in the prompt. For more info see https://github.com/magicmonty/bash-git-prompt
    git clone https://github.com/magicmonty/bash-git-prompt.git /root/.bash-git-prompt --depth=1 && \

    # Node
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update && apt-get install -y nodejs && \

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
    sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd && \

    touch /usr/local/etc/php/php.ini && \

    # Configure php.ini
    sed -i \
        -e "s/^expose_php.*/expose_php = Off/" \
        -e "s/^;date.timezone.*/date.timezone = UTC/" \
        -e "s/^memory_limit.*/memory_limit = -1/" \
        -e "s/^max_execution_time.*/max_execution_time = 300/" \
        -e "s/^; max_input_vars.*/max_input_vars = 2000/" \
        -e "s/^post_max_size.*/post_max_size = 512M/" \
        -e "s/^upload_max_filesize.*/upload_max_filesize = 512M/" \
        -e "s/^;always_populate_raw_post_data.*/always_populate_raw_post_data = -1/" \
        -e "s/^error_reporting.*/error_reporting = E_ALL/" \
        -e "s/^display_errors.*/display_errors = On/" \
        -e "s/^display_startup_errors.*/display_startup_errors = On/" \
        -e "s/^track_errors.*/track_errors = On/" \
        -e "s/^mysqlnd.collect_memory_statistics.*/mysqlnd.collect_memory_statistics = On/" \
        /usr/local/etc/php/php.ini && \

    echo "error_log = \"/proc/self/fd/2\"" | tee -a /usr/local/etc/php/php.ini

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
COPY opcache.ini /usr/local/etc/php/conf.d/
COPY xdebug.ini /usr/local/etc/php/conf.d/
COPY default.aliases.drushrc.php /etc/drush/site-aliases/

ENV NOTVISIBLE "in users profile"

RUN echo "export VISIBLE=now" >> /etc/profile && \
    # Change php fpm port
    # sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${PHP_FPM_PORT}/g" : /usr/local/etc/php-fpm.d/www.conf && \
    # sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${PHP_FPM_PORT}/g" /usr/local/etc/php-fpm.d/www.conf.default && \
    sed -i "s/#XDEBUG_IDE_KEY#/${XDEBUG_IDE_KEY}/g" /usr/local/etc/php/conf.d/xdebug.ini && \
    sed -i "s/#XDEBUG_REMOTE_PORT#/${XDEBUG_REMOTE_PORT}/g" /usr/local/etc/php/conf.d/xdebug.ini && \

    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* && \
    sed -i "s/#PHP_FPM_PORT#/${PHP_FPM_PORT}/g" /etc/supervisor/conf.d/supervisord.conf && \
        sed -i "s/#USER_EMAIL#/${USER_EMAIL}/g" /root/.gitconfig && \
         sed -i "s/#USER_NAME#/${USER_NAME}/g" /root/.gitconfig

EXPOSE 22 ${PHP_FPM_PORT} ${XDEBUG_REMOTE_PORT}

WORKDIR /var/www/${PROJECT_NAME}

# CMD ["/bin/bash", "-c", "source /root/.bashrc"]
CMD ["/usr/bin/supervisord"]


