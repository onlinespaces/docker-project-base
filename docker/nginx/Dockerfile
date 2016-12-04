FROM nginx:1.10.2
MAINTAINER Scott Collier <scott@onlinespaces.com>

ARG DOMAIN_NAME
ARG PROJECT_NAME
ARG PHP_FPM_PORT
ARG WEBSITE_DIR

RUN apt-get update && apt-get install -y \
        nano \
        net-tools

# Clean
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Clear old nginx sites
RUN rm -f /etc/nginx/sites-enabled/*
RUN rm -f /etc/nginx/sites-available/*
RUN rm -f /etc/nginx/conf.d/*

COPY nginx.conf /etc/nginx/
COPY website.conf /etc/nginx/sites-enabled/${PROJECT_NAME}.conf

RUN sed -i "s/#DOMAIN_NAME#/${DOMAIN_NAME}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
RUN sed -i "s/#PROJECT_NAME#/${PROJECT_NAME}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
RUN sed -i "s/#PHP_FPM_PORT#/${PHP_FPM_PORT}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf
RUN sed -i "s/#WEBSITE_DIR#/${WEBSITE_DIR}/g" /etc/nginx/sites-enabled/${PROJECT_NAME}.conf

RUN mkdir /etc/nginx/sites-available
RUN ln -sf /etc/nginx/sites-enabled/${PROJECT_NAME}.conf /etc/nginx/sites-available/${PROJECT_NAME}.conf
RUN echo "upstream php-upstream { server php-fpm:${PHP_FPM_PORT}; }" > /etc/nginx/conf.d/upstream.conf

RUN usermod -u 1000 www-data

EXPOSE 80 443

# RUN cat /etc/nginx/sites-enabled/${PROJECT_NAME}.conf

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/*

CMD ["nginx", "-g", "daemon off;"]