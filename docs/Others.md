# Other general services

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