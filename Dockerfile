# Usa una imagen base con PHP y Apache
FROM php:8.2-apache
# Instalar extensiones necesarias para Laravel y PostgreSQL
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    git \
    libpq-dev \
    && docker-php-ext-install zip pdo pdo_pgsql \
    && a2enmod rewrite

# Copiar los archivos del proyecto al contenedor
COPY . /var/www/html

# Establecer permisos adecuados para Laravel
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage \
    && chmod -R 775 /var/www/html/bootstrap/cache

# Cambiar la raíz de Apache al directorio "public" de Laravel
RUN sed -i 's|/var/www/html|/var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# Instalar Composer para manejar dependencias de Laravel
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
