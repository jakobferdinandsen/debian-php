FROM debian:stretch
LABEL maintainer="jakob@hexio.dk"

RUN apt-get -y clean \
    && apt-get update \
    && apt-get install -y apt-transport-https \
        lsb-release \
        ca-certificates \
        wget
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y -q \
        php7.2-fpm \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN mkdir -p /run/php/ && \
    touch /run/php/php7.2-fpm.sock
    
RUN sed -i -e "s/^error_log =/;error_log =/" /etc/php/7.2/fpm/php-fpm.conf && \
    sed -i -e "s/;daemonize = yes/daemonize = no/" /etc/php/7.2/fpm/php-fpm.conf && \
    sed -i -e "/^;error_log =/ a \
    error_log = /proc/self/fd/2 " /etc/php/7.2/fpm/php-fpm.conf

RUN echo 'listen = 9000' >> /etc/php/7.2/fpm/php-fpm.conf
    
CMD ["php-fpm7.2", "--nodaemonize", "--fpm-config", "/etc/php/7.2/fpm/php-fpm.conf"]

WORKDIR /var/www
