# Docker Dev Stack

The stack contains a setup for the next services;

- NginX
- PHP 7.1.x
- PHP 5.6.x
- MySQL
- Mailhog
- Portainer

## Install the project

Just simply run the next install command and follow the instructions

```
sh scripts/install.sh
```

For updating the stack, run;

```
sh scripts/update.sh
```

## Supported URL routing

All the formats do have multiple domain suffixes. For example; a host could end
on `.{device}.local`, `.{device}.dev` or `.{device}.oostdesign.com`.

Below only the first parts are explained.

```
http://{project-folder}.php56.{domain}
http://{project-folder}.php71.{domain}
```

The NginX configuration is made to check for existance of the next web folders;

```js
// default Symfony:
web/
// default Craft:
public/
// default DirectAdmin:
public_html/
// default Plesk:
httpdocs/
```

Otherwise it serves from the project folder root.

### Craft projects

Let's say you're building a shop. The name of the shop is "Amazing Site". Create a
folder for your project inside your projects dir (as configured in the .env file).
Example: `amazing-site/`.

The URL for this project would be;

```
http://amazing-site.craft.{domain}
```

This triggers custom NginX settings set up for Craft websites.

You're also able to put projects inside a subfolder of your projects folder, named `_craft/`. This way you have to use Craft before the name of the project. Let's see;

```
http://craft.amazing-site.{domain}
```

__Note:__ Craft projects will always be using PHP7.1

### Symfony projects

As the same from above examples regarding Craft CMS. The same applies for Symfony projects, but of course NginX config is prepared to run Symfony projects.

The URL for above "Amazing Site" project will become;

```
http://amazing-site.symfony.{domain}
```

And you're also able to use a `_symfony/` subfolder with a URL like;

```
http://symfony.amazing-site.{domain}
```

__Note:__ Symfony projects will always be using PHP7.1

## Using custom NginX config

If you want to add-in custom NginX config, just place your `.conf` files inside the Docker Dev Stack `data/` folder.

Useful when projects needs custom configuration for NginX.

## MySQL

As MySQL is served as separated container, you're not able to use `localhost` as host for your database connection. Use `mysql` for that, as that would be the name of the Docker container in your stack. As this is the name, inside your Docker-network, this will work.

For connecting from the host to your MySQL container, you could use `localhost:3306` to connect.

## Mailhog

This is a simple SMTP tool for capturing mail locally. To be sure nothing is send out for real, the PHP containers are configured to force all mail to this SMTP service.

You could view the emails via the URL;

```
http://postoffice.{domain}
```

## Portainer

The stack is also including an image of Portainer. A useful web based tool to view all Docker running elements. Like networks, images, containers, volume mounts etc.

Open portainer easily (no authorization required) via the URL;

```
http://{domain}:8888
```

## Traefik

Once you're familiar with Docker and you want to use it more project-wise and you want to dockerize your projects, you're going to need Traefik (or some other proxy service).

With Traefik you're able to launch a project as custom service within your dev stack. Easily with labels in your projects' docker-compose.yml file.