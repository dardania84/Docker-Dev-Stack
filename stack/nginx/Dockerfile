FROM nginx:1.11.12
LABEL maintainer Bert Oost <hello@bertoost.com>

# Create defaults config directory
RUN mkdir /etc/nginx/ssl
RUN mkdir /etc/nginx/defaults
RUN mkdir /etc/nginx/conf.d/custom

# Copy files where necessary
COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi_params /etc/nginx/fastcgi_params
COPY overall_params.conf /etc/nginx/overall_params.conf
COPY overall_ssl.conf /etc/nginx/overall_ssl.conf
#COPY ssl/* /etc/nginx/ssl/
COPY defaults/*.conf /etc/nginx/defaults/
COPY conf.d/*.conf /etc/nginx/conf.d/