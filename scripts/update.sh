#!/bin/sh

# Get Git updates first
git pull

# Up dev-stack
docker-compose pull
docker-compose down
docker-compose up -d