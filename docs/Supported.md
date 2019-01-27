# Supported systems

Special NginX images are provided for usage in different systems;

System                                       | Docker Image Tag(s)                | Index            | Example usage
-------------------------------------------- | ---------------------------------- | ---------------- | -------------
[Symfony 4](https://www.symfony.com)         | bertoost/nginx:symfony             | public/index.php | [Click here](examples/DcSymfony4.md)
[Symfony 2 & 3](https://www.symfony.com)     | bertoost/nginx:symfony-development | web/app_dev.php  | [Click here](examples/DcSymfony.md)
&nbsp;                                       | bertoost/nginx:symfony             | web/app.php
[Craft CMS](https://www.craftcms.com)        | bertoost/nginx:craft               | public/index.php | [Click here](examples/DcCraft.md)
[MODX CMS](https://www.modx.com)             | bertoost/nginx:modx                | public/index.php | [Click here](examples/DcModx.md)

The corresponding NginX image tags could be found here on [Docker hub](https://hub.docker.com/r/bertoost).