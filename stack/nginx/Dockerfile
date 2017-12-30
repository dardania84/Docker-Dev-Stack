FROM nginx:stable-alpine
LABEL maintainer Bert Oost <hello@bertoost.com>

RUN mkdir /etc/nginx/conf.d/custom

# Copy files where necessary
COPY defaults/nginx.conf /etc/nginx/nginx.conf
COPY defaults/fastcgi_params /etc/nginx/fastcgi_params
COPY defaults/overall_params.conf /etc/nginx/overall_params.conf
COPY defaults/overall_ssl.conf /etc/nginx/overall_ssl.conf

# Copy default NginX config
COPY conf.d/default.conf /etc/nginx/conf.d/default.conf