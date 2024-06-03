# Use an official Apache runtime as a parent image
FROM ubuntu:22.04

# No tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install software-properties-common -y \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get install lsb-release -y \
    && apt-get install apt-transport-https -y \
    && apt-get install ca-certificates -y \
    && apt-get install wget -y \
    && apt-get install curl -y \
    && apt-get install zip -y \
    && apt-get install unzip -y \
    && apt-get install unixodbc-dev -y \
    && apt-get install zlib1g-dev -y \
    && apt-get install libpng-dev -y \
    && apt-get clean all -y

# RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
# RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list 

# No tty
ENV DEBIAN_FRONTEND noninteractive

# Install required dependencies
RUN apt-get update \
    && apt-get install -y \
        # libfcgi-bin \
        # libapache2-mod-fcgid \ 
        apache2 \
        supervisor \
        # php-fpm \
        php5.6 \
        php5.6-dev \
        php5.6-fpm \
        php5.6-pdo \
        php5.6-mysql \
        php5.6-mbstring \
        php5.6-exif \
        php5.6-xml \
        php5.6-gd \
        php5.6-zip \
        php5.6-soap \
        php7.4 \
        php7.4-dev \
        php7.4-fpm \
        php7.4-pdo \
        php7.4-pdo-dblib \
        php7.4-mysql \
        php7.4-mbstring \
        php7.4-exif \
        php7.4-xml \
        php7.4-gd \
        php7.4-zip \
        php7.4-soap \
        php7.4-bcmath \
        php7.4-memcache \
        php7.4-memcached \
        php8.2 \
        php8.2-dev \
        php8.2-fpm \
        php8.2-pdo \
        php8.2-pdo-dblib \
        php8.2-mysql \
        php8.2-mbstring \
        php8.2-exif \
        php8.2-xml \
        php8.2-gd \
        php8.2-zip \
        php8.2-soap \
        php8.2-memcache \
        php8.2-memcached

# Enable required Apache modules
RUN a2ensite default-ssl
# RUN a2enmod actions alias fcgid setenvif ssl
RUN a2enmod proxy proxy_fcgi rewrite setenvif ssl

RUN a2enconf php7.4-fpm

RUN pecl install sqlsrv pdo_sqlsrv
RUN printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
RUN printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 7.4 sqlsrv pdo_sqlsrv

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Expose port 80
EXPOSE 80 443

COPY ./init.sh /var/www/init.sh
RUN chmod 755 /var/www/init.sh

# Supervisor
RUN mkdir -p /run/php/

# RUN touch /var/run/supervisor.sock
# RUN chmod 777 /var/run/supervisor.sock

CMD ["/bin/bash", "/var/www/init.sh"]

# CMD [ "/lib/systemd/systemd" ]

# CMD ["/bin/bash", "/var/www/init.sh"]

# Start Apache in the foreground
# CMD ["apache2-foreground", ;]
# CMD ["apache2ctl", "-D", "FOREGROUND"]