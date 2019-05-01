# MODX CMS docker-compose example

Below an exmaple of the `docker-compose.yml` file using the MODX CMS NginX image.

Put this file in the root of your project (checkout);

```yaml
version: "3.3"
services:
  nginx:
    image: bertoost/nginx:modx
    restart: always
    links:
      - php:php
    volumes:
      - ".:/var/www/html:rw"
    labels:
      traefik.enable: 'true'
      traefik.port: '80'
      # Tell Traefik which domain should be mapped
      traefik.frontend.rule: 'Host:my-modx-project.local'
      # You can also use environment variables here (or a .env file)
      # traefik.frontend.rule: 'Host:my-modx-project.${DEV_HOST_DOMAIN}'
      traefik.docker.network: 'webgateway'
    networks:
      - development
      - webgateway

  php:
    # Using PHP7.2
    image: bertoost/php:7.2-fpm-dev
    # OR Using PHP7.3
    image: bertoost/php:7.3-fpm-dev
    restart: always
    environment:
      CURRENT_ENV: ${DEV_CURRENT_ENV-development}
      XDEBUG_HOST: ${DEV_HOST_DOMAIN}
      BLACKFIRE_HOST: ${DEV_HOST_DOMAIN}
      BLACKFIRE_SERVER_ID: ${DEV_BLACKFIRE_SERVER_ID-''}
      BLACKFIRE_SERVER_TOKEN: ${DEV_BLACKFIRE_SERVER_TOKEN-''}
      # PHP Environment variables
      # PHP_DATE_TIMEZONE: Europe/Paris
      # PHP_MAX_EXECUTION_TIME: 60
      # PHP_MEMORY_LIMIT: 256M
      # PHP_POST_MAX_SIZE: 128M
      # PHP_UPLOAD_MAX_FILESIZE: 128M
    volumes:
      - './:/var/www/html:rw'
      - '${DEV_COMPOSER_DATA-~/.composer}:/home/php/.composer'
    networks:
      - development

  # Add more services here if your project needs it

networks:
  webgateway:
    external:
      name: webgateway
  development:
    external:
      name: development
```

And easily start your project with the up-command;

```terminal
docker-compose up -d
```