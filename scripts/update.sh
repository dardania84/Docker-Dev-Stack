#!/bin/sh

# Get Git updates first
git pull

# Check .env file
source helpers/envfile.sh

# Check and install networks
source helpers/networks.sh

# Up dev-stack
docker-compose pull
docker-compose down
docker-compose up -d