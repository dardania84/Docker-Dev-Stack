# Docker Dev Stack

[![Build Status](https://travis-ci.org/bertoost/Docker-Dev-Stack.svg?branch=master)](https://travis-ci.org/bertoost/Docker-Dev-Stack)

The purpose of this development stack with Docker images is to help setting up a local environment for development of PHP/MySQL projects. It's not meant to be used in production.

## Supported systems

Special NginX images are provided for usage in different systems;

System                                       | Docker Image Tag(s)                | Index       | Example usage
-------------------------------------------- | ---------------------------------- | ----------- | -------------
[Symfony framework](https://www.symfony.com) | bertoost/nginx:symfony-development | app_dev.php | [Click here](docs/examples/DcSymfony.md)
&nbsp;                                       | bertoost/nginx:symfony             | app.php
[Craft CMS](https://www.craftcms.com)        | bertoost/nginx:craft               | index.php   | [Click here](docs/examples/DcCraft.md)
[MODX CMS](https://www.modx.com)             | bertoost/nginx:modx                | index.php   | [Click here](docs/examples/DcModx.md)

The corresponding NginX image tags could be found here on [Docker hub](https://hub.docker.com/r/bertoost).

## Stack contents

The stack contains a setup for the next Docker services;

- NginX
  - Base PHP projects support
  - Symfony configuration (not with tested v4.0 yet)
  - Craft CMS projects
  - MODX CMS projects
- PHP 7.1.x / 7.2.x (FPM)
  - Libraries included:
    - Locales: en_US and nl_NL supported (currently)
    - ImageMagic
    - GD support
    - APCu support
    - LibSodium support
  - Composer installed
  - Development additions:
    - Xdebug enabled
    - Blackfire available
- MySQL
  - Port 3306 is mapped from your host-machine
- Mailhog (catching mail)
- Portainer (UI for your Docker setup)

## More to read before...

Before you use these dev stack, please read the following topics.

- [Installation](docs/Installation.md)
- [Traefik usage](docs/Traefik.md)
  - [Frontends vs. Backends](docs/Traefik.md#frontends-vs-backends)
  - [Per project basis](docs/Traefik.md#using-traefik-on-per-project-basis)
  - [Auto-added binary files](docs/Traefik.md#auto-added-binary-files)
- [MySQL, Mailhog & Portainer](docs/Others.md)
- [Dev Stack Fallback setup](docs/fallback/Setup.md)
- [Custom NginX Config](docs/CustomNginx.md)
  - [Configuration folder](docs/CustomNginx.md#configuration-folder)
  - [Environment variables](docs/CustomNginx.md#using-environment-variables)
- [Building images](docs/BuildImages.md)