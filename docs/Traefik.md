# Traefik

Træfik (pronounced like traffic) is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease. It supports several backends (Docker, Swarm mode, Kubernetes, Marathon, Consul, Etcd, Rancher, Amazon ECS, and a lot more) to manage its configuration automatically and dynamically.

![Traefik](https://docs.traefik.io/img/architecture.png "Traefik")

## Frontends vs. Backends

Please read the [official docs](https://docs.traefik.io/basics/) if you don't know what frontends and backends of Traefik are.

## Open Traefik in your browser

Traefik can be reached via the next domain

```terminal
http://traefik.local
```

## Using Traefik on per-project basis

__Note:__ Below you will see some environment variables. Please refer to the [installation](Installation.md) guide how to configure these variables.

For example, let's say we have a Symfony project we want to run;

1. Add a `docker-compose.yml` in the root of your project.
2. Configure the services you have to use, like one of the examples below
3. Up your project by running `docker-compose up -d`

- [Symfony example file](examples/DcSymfony.md)
- [Craft CMS example file](examples/DcCraft.md)
- [MODX CMS example file](examples/DcModx.md)

## Auto-added binary files

When you're using my PHP images, you will notice that your project contains a `bin/` directory with at least an `php` and `composer` file in it. You should ignore this files from your repository (do not commit them).

These files are meant to act as shortcut for running php and composer commands from your host-machine inside the PHP docker image your project is using. These files are updated automatically when you `down` and `up` your project. It contains the ID of the container to pass the commands.

If you don't want these handy shortcuts, please remove the `BINARY_DIRECTORY` environment variable from the above configuration.

__Example usage:__

```terminal
$ bin/php --version
```

```terminal
$ bin/composer --version
```

__Note:__ Windows & Mac users should use `sh` command in front!

For example, if you have to require a package with composer, use;

```terminal
$ bin/composer require vendor/package-name
```

And if you're running a Symfony project, you probably want to use the `bin/console` command. Here's how to use that with the project-containers;

```terminal
$ bin/php bin/console list
```