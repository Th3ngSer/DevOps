FROM jenkins/jenkins:lts
USER root

# Install PHP 8.4 and Dependencies
RUN apt-get update && apt-get install -y \
    lsb-release \
    ca-certificates \
    curl \
    gnupg

# Add PHP Repository and Ansible
RUN curl -sS https://packages.sury.org/php/apt.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/php.gpg \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt-get update && apt-get install -y \
    php8.4 php8.4-xml php8.4-mbstring php8.4-curl php8.4-zip php8.4-fileinfo \
    ansible nodejs npm \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

USER jenkins
