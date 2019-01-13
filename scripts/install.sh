#!/bin/sh

# Copy default.env to .env if not already exists
if [ ! -f ".env" ]
then
    cp default.env .env
    echo "Please check the .env file and change the values to your needs. Then re-run install.sh script again."
    exit
fi

# Create necessary networks
NETWORKS[0]="development"
NETWORKS[2]="webgateway"

for NETWORKNAME in "${NETWORKS[@]}"
do
    CHECK_NETWORK="$(docker network inspect --format={{.Id}} ${NETWORKNAME} 2>&1)"
    if [[ $CHECK_NETWORK == *"No such network"* ]]; then
        echo "Creating netork: ${NETWORKNAME}"
        docker network create $NETWORKNAME
    fi
done

# Up dev-stack
docker-compose up -d