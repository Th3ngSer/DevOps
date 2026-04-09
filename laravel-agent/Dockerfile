FROM jenkins/ssh-agent:latest

USER root

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    openssh-client \
    rsync \
    php8.4 php8.4-xml php8.4-mbstring php8.4-curl php8.4-zip php8.4-fileinfo \
    ansible \
    nodejs npm \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

