#!/bin/sh

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