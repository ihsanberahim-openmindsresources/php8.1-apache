FROM php:8.1-apache


ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
    git \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libbz2-dev \
    libzip-dev \
    libxml2-dev \
    cron \
    supervisor \
    && docker-php-ext-install -j$(nproc) zip \
    pdo_mysql \
    opcache \
    bcmath \
    bz2 \
    soap \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-install -j$(nproc) opcache \
    && pecl install redis grpc \
    && docker-php-ext-enable redis grpc \
    && rm -rf /var/lib/apt/lists/*