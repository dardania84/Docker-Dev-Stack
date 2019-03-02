<p align="center"><img src="images/nginx-logo.svg" alt="NginX" width="400"></p>

<hr>

Sometimes it is necessary to add custom configuration for the NginX webserver.

I have taken this into account within this Dev Stack.

## Configuration folder

From the Dev Stack root, you will find the `data/nginx/` folder.

This folder is used to put your custom configurations in for NginX.

## Using environment variables

> My images are built with a parser for environment variables inside the NginX configuration files. This is not possible by default.

If you're using `filename.placeholder` instead of `filename.conf`, inside the container path `/etc/nginx/conf.d/`, the NginX image is going to scan those files files and converts them into `filename.conf` with parsed environment variables.

Therefor you have to notice, that you can't use the dollar sign `$` directly. You have to "escape" them, otherwise it will not converted correctly. For example;

```nginx
server {
    ...
    location ~ \.php$ {
        ...
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;
    }
    ...
}
```

Will become;

```nginx
server {
    ...
    location ~ \.php${DOLLAR} {
        ...
        fastcgi_param SCRIPT_NAME ${DOLLAR}fastcgi_script_name;
    }
    ...
}
```

You can see the dollar signs are replaced by `${DOLLAR}` and that's because the convert-script is not recognize what is an environment variable or not.