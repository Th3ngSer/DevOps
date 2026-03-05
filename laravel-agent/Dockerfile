FROM jenkins/ssh-agent:latest

USER root

RUN apt update && apt install -y \
    php \
    php-xml \
    php-mbstring \
    php-curl \
    php-zip \
    php-fileinfo \
    npm \
    curl

# Install Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php \
    && mv composer.phar /usr/local/bin/composer \
    && rm composer-setup.php