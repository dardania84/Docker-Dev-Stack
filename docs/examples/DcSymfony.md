# Symfony 2 & 3 docker-compose example

Below an exmaple of the `docker-compose.yml` file using the Symfony (development) NginX image.

Put this file in the root of your project (checkout);

```yaml
version: "3.3"
services:
  nginx:
    image: bertoost/nginx:symfony-development
    restart: always
    links:
      - php:php
    volumes:
      - ".:/var/www/html:rw"
    labels:
      traefik.enable: 'true'
      traefik.port: '80'
      # Tell Traefik which domain should be mapped
      traefik.frontend.rule: 'Host:my-symfony-project.local'
      # You can also use environment variables here (or a .env file)
      # traefik.frontend.rule: 'Host:my-symfony-project.${DEV_HOST_DOMAIN}'
      traefik.docker.network: 'webgateway'
    networks:
      - development
      - webgateway

  php:
    # Using PHP7.2
    image: bertoost/php72:fpm-development
    # OR Using PHP7.3
    image: bertoost/php73:fpm-development
    restart: always
    environment:
      CURRENT_ENV: ${DEV_CURRENT_ENV-development}
      XDEBUG_HOST: ${DEV_HOST_DOMAIN}
      BLACKFIRE_HOST: ${DEV_HOST_DOMAIN}
      BLACKFIRE_SERVER_ID: ${DEV_BLACKFIRE_SERVER_ID-''}
      BLACKFIRE_SERVER_TOKEN: ${DEV_BLACKFIRE_SERVER_TOKEN-''}
    volumes:
      - './:/var/www/html:rw'
      - '${DEV_COMPOSER_DATA-~/.composer}:/home/php/.composer'
    external_links:
      - ${DEV_MYSQL_CONTAINERNAME-mysql}:mysql
      - ${DEV_MAIL_CONTAINERNAME-postoffice}:mail.docker.local
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