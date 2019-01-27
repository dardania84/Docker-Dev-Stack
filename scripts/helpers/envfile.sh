#!/bin/sh

# Copy default.env to .env if not already exists
if [ ! -f ".env" ]
then
    cp default.env .env
    echo "Please check the .env file and change the values to your needs. Then re-run script again."
    exit
fi