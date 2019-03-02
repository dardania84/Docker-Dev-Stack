# Build images

To build the images, based on the configuration, and overwrite used tags, use the build script, like;

```
sh scripts/build.sh <path to Dockerfile> [options]
```

Option    | Description
--------- | ------------------------------
`--build` | To trigger building the image
`--push`  | To trigger pushing the image

__Example usage__

```
sh scripts/build.sh stack/php/7.3/Dockerfile.fpm --build --push
```

This will build the image `{username}/php:7.3-fpm`
Using a path is possible too;

```
sh scripts/build.sh stack/php71 --build --push
```

This will scan the directory for any `Dockerfile*`'s and will ask you to continue or not.