# Stack contents

The stack contains a setup for the next Docker services;

- NginX
  - Base PHP projects support
  - Symfony configuration (not with tested v4.0 yet)
  - Craft CMS projects
  - MODX CMS projects
- PHP 7.2.x / 7.3.x (FPM)
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

## PHP 7.2 & PHP 7.3 customizations

You're able to change some `php.ini` behavior settings by creating environment variables inside your .env file.

| Name                    | Default value    | Description                                |
|-------------------------|------------------|--------------------------------------------|
| PHP_DATE_TIMEZONE       | Europe/Amsterdam | The timezone for PHP's datetime stuff      |
| PHP_MAX_EXECUTION_TIME  | 60               | The number of seconds a script can execute |
| PHP_MEMORY_LIMIT        | 256M             | The memory limit for PHP processes         |
| PHP_POST_MAX_SIZE       | 128M             | The max size you can POST                  |
| PHP_UPLOAD_MAX_FILESIZE | 128M             | The max filesize for uploading files       |

> __Note:__ not implemented in PHP7.1 image. Since that image will not be activily maintained anymore.