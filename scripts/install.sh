#!/bin/sh

# Copy default.env to .env if not already exists
if [ ! -f ".env" ]
then
    cp default.env .env
    echo "Please check the .env file and change the values to your needs. Then re-run install.sh script again."
    exit
fi

# Create necessary networks
docker network create webgateway
docker network create development

# Up dev-stack
docker-compose up -d