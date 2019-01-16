# Docker Dev Stack

[![Build Status](https://travis-ci.org/bertoost/Docker-Dev-Stack.svg?branch=master)](https://travis-ci.org/bertoost/Docker-Dev-Stack)

<aside class="notice">
The purpose of this development stack with Docker images is to help setting up a local environment for development of PHP/MySQL projects. It's not meant to be used in production.
</aside>

Before you use this dev stack, please read the following topics.

- [Stack contents (services)](docs/Contents.md)
- [Installation](docs/Installation.md)
- [Supported systems](docs/Supported.md)
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