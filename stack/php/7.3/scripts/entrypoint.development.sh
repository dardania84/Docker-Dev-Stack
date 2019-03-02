#!/bin/bash

if [[ "${BINARY_DIRECTORY}" != "" ]]; then

    mkdir -p /var/www/html/${BINARY_DIRECTORY}
    cp /home/php/projects_bin/* /var/www/html/${BINARY_DIRECTORY}

    HOSTNAME=$(cat /etc/hostname)

    find /var/www/html/${BINARY_DIRECTORY} -type f -exec sed -i "s/CONTAINER_ID/${HOSTNAME}/" {} \;
fi

# Update composer at startup
composer self-update

# Run PHP-FPM at last
php-fpm