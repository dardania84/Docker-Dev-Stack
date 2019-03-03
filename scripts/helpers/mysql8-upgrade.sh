#!/bin/sh

read -p "Are you sure you want to migrate to MySQL 8? [y/N] " CONTINUE

if [[ ! ${CONTINUE} =~ ^[Yy]$ ]]; then
    echo "Exiting..."
    exit 0
fi

echo ""
echo "Okay! Here we go..."


# Check if both services are running
MYSQL_UP=$(docker ps -q -f status=running -f name=^/mysql$)
MYSQL8_UP=$(docker ps -q -f status=running -f name=^/mysql8$)

if [[ ! "${MYSQL_UP}" ]]; then

    echo ""
    echo "MySQL container down... I'll bring it up!"

    docker-compose up -d mysql

    # Try to connect to new server...
    echo "Trying to connect to the MySQL container..."
    MYSQL8CONNECT=$(docker exec -it mysql bash -c "MYSQL_PWD=MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysql -u root -e exit")

    while [[ "${MYSQL8CONNECT}" == *"Can't connect"* ]]; do

        sleep 3 # give it some time

        echo "Trying to connect to the MySQL container..."
        MYSQL8CONNECT=$(docker exec -it mysql bash -c "MYSQL_PWD=MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysql -u root -e exit")
    done

    echo "Yeah! We're in! Continue..."
fi


if [[ ! "${MYSQL8_UP}" ]]; then

    echo ""
    echo "MySQL 8 container down... I'll bring it up!"

    docker-compose -f scripts/helpers/mysql8/docker-compose.yml up -d

    # Try to connect to new server...
    echo "Trying to connect to the MySQL 8 container..."
    MYSQL8CONNECT=$(docker exec -it mysql8 bash -c "MYSQL_PWD=MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysql -u root -e exit")

    while [[ "${MYSQL8CONNECT}" == *"Can't connect"* ]]; do

        sleep 3 # give it some time

        echo "Trying to connect to the MySQL 8 container..."
        MYSQL8CONNECT=$(docker exec -it mysql8 bash -c "MYSQL_PWD=MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysql -u root -e exit")
    done

    echo "Yeah! We're in! Continue..."
fi

# Still down?!
MYSQL_UP=$(docker ps -q -f status=running -f name=^/mysql$)
MYSQL8_UP=$(docker ps -q -f status=running -f name=^/mysql8$)

if [[ ! "${MYSQL_UP}" ]] || [[ ! "${MYSQL8_UP}" ]]; then

    echo ""
    echo "One of both MySQL services is still not running. I can't continue."

    if [[ ! "${MYSQL_UP}" ]]; then echo "  - mysql: down"; else echo "  - mysql: up"; fi
    if [[ ! "${MYSQL8_UP}" ]]; then echo "  - mysql8: down"; else echo "  - mysql8: up"; fi

    echo ""
    exit 1
fi

# Start backing up databases
echo ""
echo "Create directory to backup to (if not exists)..."
echo ""

# Create temp dump directory in container
mkdir -p data/mysql_dumps
docker exec -it mysql bash -c "mkdir -p /var/mysql_dumps/"
docker exec -it mysql8 bash -c "mkdir -p /var/mysql_dumps/"

# Walk over all databases to dump
for DB in $(docker exec -it mysql bash -c "MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysql -u root -e 'show databases' -s --skip-column-names"); do

    # trim spaces/tabs
    DB=$(echo ${DB} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    # Only dump none-default databases
    if [[ "${DB}" != "information_schema" ]] && [[ "${DB}" != "mysql" ]] && [[ "${DB}" != "performance_schema" ]] && [[ "${DB}" != "sys" ]]; then

        echo "${DB} ..."
        echo "-> Create database dump from: mysql..."

        CTDUMPPATH="/var/mysql_dumps/${DB}.sql"
        LOCALDUMPPATH="./data/mysql_dumps/${DB}.sql"

        # Create database dump
        docker exec -it mysql bash -c "MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysqldump -u root --databases ${DB} > ${CTDUMPPATH}"

        # Copy from container (since there is no mount for this)
        docker cp mysql:${CTDUMPPATH} ${LOCALDUMPPATH}

        echo "-> Import database dump to: mysql8..."

        # Copy dump into target container
        docker cp ${LOCALDUMPPATH} mysql8:${CTDUMPPATH}

        # Import with mysql
        docker exec -it mysql8 bash -c "MYSQL_PWD=${MYSQL_PASSWORD:-mysql} mysql -u root < ${CTDUMPPATH}"
    fi
done

# Remove temp dump directory
echo ""
echo "Cleaning up database dump directories..."
echo ""

docker exec -it mysql bash -c "rm -rf /var/mysql_dumps/"
docker exec -it mysql8 bash -c "rm -rf /var/mysql_dumps/"
rm -rf data/mysql_dumps


# Bring down both mysql services
echo "Stopping MySQL containers..."
docker stop mysql mysql8

# Rename old data/log directory
echo "Backing up old MySQL directories (to be sure)..."
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
