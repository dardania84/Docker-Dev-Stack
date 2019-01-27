#!/bin/sh

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