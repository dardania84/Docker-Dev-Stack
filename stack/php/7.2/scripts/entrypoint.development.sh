#!/bin/bash

if [[ "${BINARY_DIRECTORY}" != "" ]]; then

    mkdir -p /var/www/html/${BINARY_DIRECTORY}
    cp /home/php/projects_bin/* /var/www/html/${BINARY_DIRECTORY}

    HOSTNAME=$(cat /etc/hostname)

    find /var/www/html/${BINARY_DIRECTORY} -type f -exec sed -i "s/CONTAINER_ID/${HOSTNAME}/" {} \;
fi

# Update composer at startup
composer self-update

# check if there was a command passed
# required by Jenkins Docker plugin: https://github.com/docker-library/official-images#consistency
if [ "$1" ]; then
    # execute it
    exec "$@"
fi

# Run PHP-FPM at last
php-fpm