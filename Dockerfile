# Use phusion/baseimage as base image. (using latest is bad)
FROM stratolinux/baseimage-docker:0.9.19

# shared volume
# VOLUME ["/var/www/html"]
# ports needed
EXPOSE 80


# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# install the PHP extensions we need
RUN apt-get update && apt-get install -y \
    apache2 \
    git \
    php \
    libpng12-dev \
    libjpeg-dev \
    zlib1g-dev \
		php-gd \
    php-zip \
    php-mbstring \
    wget \
    unzip \
    libapache2-mod-php \
    php-curl \
    php-xml

# enable apache mods
RUN a2enmod rewrite expires

# set recommended PHP.ini settings

ENV GRAV_VERSION 1.1.15
RUN cd /tmp && \
  rm /var/www/html/index.html && \
  wget https://getgrav.org/download/core/grav-admin/1.1.15 -O grav-admin.zip && \
  unzip grav-admin.zip && \
	rsync -a /tmp/grav-admin/ /var/www/html && \
  chown -R www-data:www-data /var/www


COPY etc/ /etc/

RUN find /etc/service -name run -exec chmod +x {} \;

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
