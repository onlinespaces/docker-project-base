#!/bin/sh

if [ ! -d "/etc/nginx/sites-enabled" ]; then
    mkdir /etc/nginx/sites-enabled
fi

if [ -n "$APPLICATION_TYPE" ]; then
    if [ "$APPLICATION_TYPE" = "drupal8" ]; then
        cp /etc/opt/docker-files/drupal8.conf /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
    else
        cp /etc/opt/docker-files/symfony.conf /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
    fi
fi

sed -i "s/#DOMAIN_NAME#/${DOMAIN_NAME}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
sed -i "s/#PROJECT_NAME#/${PROJECT_NAME}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
sed -i "s/#PHP_FPM_PORT#/${PHP_FPM_PORT}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
sed -i "s/#WEBSITE_DIR#/${WEBSITE_DIR}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf

mkdir /etc/nginx/sites-available
ln -sf /etc/nginx/sites-enabled/${PROJECT_NAME}.conf /etc/nginx/sites-available/${PROJECT_NAME}.conf

# Set PHP-FPM Port Forwarding
echo "upstream php-upstream { server php-fpm:${PHP_FPM_PORT}; }" > /etc/nginx/conf.d/upstream.conf
usermod -u 1000 www-data

exec nginx -g "daemon off;"