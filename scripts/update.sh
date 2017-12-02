#!/bin/sh

# Get Git updates first
git pull

# Up Traefik for local development
docker-compose -f traefik/docker-compose.yml pull
docker-compose -f traefik/docker-compose.yml down
docker-compose -f traefik/docker-compose.yml up -d

# Up dev-stack
docker-compose pull
docker-compose down
docker-compose up -d