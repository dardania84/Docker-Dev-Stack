# Install the project

Copy the `default.env` to `.env` and change the contents to your need.

> __Note:__ You can also pass some of the variables to your environment if you want them globally available in all your projects. For example the `DEV_HOST_DOMAIN` and `DEV_HOST_IP` are good ones to set global. See section below.

## Manual

### Docker networks
Add a new Docker networks first

```bash
# Network for development (PHP, MySQL images etc)
docker network create development

# Network for Traefik webservers (NginX)
docker network create webgateway
```

### Global environment variables (recommended)

I'll advice you to register some environment variables on your machine. This will become helpful when dealing with a custom hostname per project (see [examples](examples/Index.md)).

```bash
# Setup a root hostname
DEV_HOST_DOMAIN=yourname.local

# Also set your machine's local IP address for stuff like xDebug
DEV_HOST_IP=123.123.123.123
```

## Using scripts

Just simply run the next install command and follow the instructions.

```bash
scripts/install.sh
```

For updating the stack, run;

```bash
scripts/update.sh
```

## Windows users

I'll recommend to use [CMD-er](http://cmder.net/) on Windows. Since it comes with a couple of nice built-in features to make life a bit easier.

__Note:__ to run bash scripts as above on commandline interface, prefix commands with `sh` command. So it should look like `sh scripts/install.sh`
