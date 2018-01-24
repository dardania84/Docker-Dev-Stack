# Docker Dev Stack

The purpose of this development stack with Docker images is to help setting up a local environment for development of PHP/MySQL projects. It's not meant to be used in production.

Also a special configured images ar available for [Symfony framework](https://www.symfony.com) and [Craft CMS](https://www.craftcms.com) projects. See my [Docker hub](https://hub.docker.com/r/bertoost) images for the right tags to use.

The stack contains a setup for the next Docker services;

- NginX
  - Base PHP7.1 projects support
  - Symfony configuration (not with tested v4.0 yet)
  - Craft CMS projects
- PHP 7.1.x (FPM)
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
- [MySQL, Mailhog & Portainer](docs/Others.md)
- [Building images](docs/BuildImages.md)