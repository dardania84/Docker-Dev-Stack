# Other general services

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
http://portainer.{domain}
```