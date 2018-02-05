FROM nginx:1.13
MAINTAINER Scott Collier <scott@onlinespaces.com>

ARG APPLICATION_TYPE
ARG PROJECT_NAME
ARG WEBSITE_DIR

ENV APPLICATION_TYPE=${APPLICATION_TYPE}
ENV PROJECT_NAME=${PROJECT_NAME}
ENV WEBSITE_DIR=${WEBSITE_DIR}

ENV TERM xterm

RUN export TERM=xterm && \
    apt-get update && apt-get install -y \
        nano \
        net-tools \
        && \

    # Clean
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \

    # forward request and error logs to docker log collector
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \

    # Clear old nginx sites
    rm -f /etc/nginx/sites-enabled/* && \
    rm -f /etc/nginx/sites-available/* && \
    rm -f /etc/nginx/conf.d/* && \

    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* && \
    mkdir /opt/docker-files

COPY nginx.conf /etc/nginx/
COPY conf.d/* /etc/opt/docker-files/

WORKDIR /var/www/${PROJECT_NAME}

EXPOSE 80 443

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

CMD ["/usr/local/bin/docker-entrypoint.sh"]