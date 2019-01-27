# Install the project

Copy the `default.env` to `.env` and change the contents to your need.

> __Note:__ You can also pass some of the variables to your environment if you want them globally available in all your projects. For example the `DEV_HOST_DOMAIN` and `DEV_HOST_IP` are good ones to set global.

## Manual

Add a new Docker networks first

```terminal
# Network for development (PHP, MySQL images etc)

docker network create development

# Network for Traefik webservers (NginX)

docker network create webgateway
```

## Using scripts

Just simply run the next install command and follow the instructions.

```terminal
$ scripts/install.sh
```

For updating the stack, run;

```terminal
$ scripts/update.sh
```

## Windows users

I'll recommend to use [CMD-er](http://cmder.net/) on Windows. Since it comes with a couple of nice built-in features to make life a bit easier.

__Note:__ to run bash scripts as above on commandline interface, prefix commands with `sh` command. So it should look like `sh scripts/install.sh`
