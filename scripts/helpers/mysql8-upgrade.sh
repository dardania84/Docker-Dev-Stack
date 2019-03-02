#!/bin/sh

INITIALIZE=false
FINALIZE=false

while [[ "$1" != "" ]]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --init)
            INITIALIZE=true
            ;;
        --finalize)
            FINALIZE=true
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

# Check
if [[ "${INITIALIZE}" = true ]] && [[ "${FINALIZE}" = true ]]; then
    echo ""
    echo "Both --init OR --finalize is not possible. First use --init, then --finalize"
    echo ""
    exit 1
fi

if [[ "${INITIALIZE}" = false ]] && [[ "${FINALIZE}" = false ]]; then
    echo ""
    echo "At least one from --init OR --finalize is required. First use --init, then --finalize"
    echo ""
    exit 1
fi

# Initialize upgrade
if [[ "${INITIALIZE}" = true ]]; then

    docker-compose -f scripts/helpers/mysql8/docker-compose.yml up -d

    echo ""
    echo "You should be able to connect to the new MySQL server on localhost:13306."
    echo "NOTICE: it can take a little while. The first time, MySQL needs some start-up time."
    echo ""
    echo "Use your favorite client tool (Sequel Pro / HeidiSQL) to export or transfer your databases to the new MySQL server."
    echo "After you're done, use this command with --finalize to switch"
    echo ""

    exit 0

elif [[ "${FINALIZE}" = true ]]; then

    # Check if both services are running
    MYSQL_UP=$(docker ps -q -f status=running -f name=^/mysql$)
    MYSQL8_UP=$(docker ps -q -f status=running -f name=^/mysql8$)

    if [[ ! "${MYSQL_UP}" ]] || [[ ! "${MYSQL8_UP}" ]]; then

        echo ""
        echo "One of both MySQL services (mysql or mysql8) is not running. I can't continue."

        if [[ ! "${MYSQL_UP}" ]]; then echo "  - mysql: down"; else echo "  - mysql: up"; fi
        if [[ ! "${MYSQL8_UP}" ]]; then echo "  - mysql8: down"; else echo "  - mysql8: up"; fi

        echo ""
        echo "Use --init for the first time!"
        echo ""
        exit 1
    fi

    # Bring down both mysql services
    echo "Stopping MySQL containers..."
    docker stop mysql mysql8

    # Rename old data/log directory
    echo "Backing up old MySQL directories..."
    mv data/mysql/ data/mysql_backup/
    mv logs/mysql/ logs/mysql_backup/

    echo "Prepare new MySQL 8 directories..."
    mv data/mysql8/ data/mysql/
    mv logs/mysql8/ logs/mysql/

    # Set MySQL version in .env file
    ISINENVFILE=$(cat .env | grep -c "MYSQL_VERSION=8.0")
    if [[ ${ISINENVFILE} -eq 0 ]]; then
        echo "Configure .env file set MySQL to v8.0..."
        echo "\n\n# Set MySQL version by helper\nMYSQL_VERSION=8.0" >> .env
    else
        echo "MySQL already set to v8.0 in .env file. Continue..."
    fi

    # Up mysql service again
    echo "Bringing up new MySQL again..."
    docker-compose up -d mysql

    # Remove mysql8 container
    docker rm -v mysql8
fi