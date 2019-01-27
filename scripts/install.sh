#!/bin/sh

# Check .env file
source helpers/envfile.sh

# Check and install networks
source helpers/networks.sh

# Up dev-stack
docker-compose up -d