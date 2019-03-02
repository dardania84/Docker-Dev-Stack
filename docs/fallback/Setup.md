# Dev Stack Fallback Setup

Sometimes you don't want to up a whole project configuration for a single script. Testing things out, or just run a project which is not yet ready or supported by the provided images.

For this projects there is a fallback launched when you up the Dev Stack.

## How it works

By default there is a project directory when you checkout this repository. It contains a phpinfo "project". You can change this default projects folder path with overwrite the `PROJECTS_DIR` environment variable inside the `.env` file (check the `default.env`).

Traefik is configured to load this fallback as last (regarding custom project domains via Traefik). Meaning, if any dockerized project is having their own config/setup, it's loaded and used first above the fallback projects.

## Supported URLs

The next URLs are leading to your projects-directory loaded via PHP7.2

```bash
http://my-project.php72.{domain}
```

This next URLs are leading to your projects-directory loaded via PHP7.3

```bash
http://my-project.php73.{domain}
```

> In above example the folder `my-project/` should exist in the projects-directory. The name of the directory inside the projects-directory is used as first part.

## Document root

Inside a project directory, NginX is looking for several options. Below in order;

1. `{project-dir}/public_html/`
2. `{project-dir}/public/`
3. `{project-dir}/web/`
4. `{project-dir}/httpdocs/`
5. `{project-dir}/`

It is looking for an `index.php`, `index.html` and last `index.htm`

_By default there is no friendly-url support in this fallback system._