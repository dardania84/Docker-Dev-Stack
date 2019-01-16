# Stack contents

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