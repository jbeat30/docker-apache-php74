# Base image
FROM php:7.4-apache

# Install modules
RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install apt-utils libonig-dev libpq-dev && \
    docker-php-ext-install pdo_mysql mysqli mbstring gettext

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Configure Apache
RUN echo '<Directory /var/www/html>\n\
    Options FollowSymLinks\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/apache2.conf && \
a2enmod mpm_prefork rewrite

# Configure PHP settings
RUN echo "date.timezone = Asia/Seoul" > /usr/local/etc/php/php.ini && \
    sed -i 's/short_open_tag = Off/short_open_tag = On/' /usr/local/etc/php/php.ini

# Copy application files to container
COPY . /var/www/html

# Expose port 80 for web access
EXPOSE 80

# Start Apache server
CMD ["apachectl", "-D", "FOREGROUND"]