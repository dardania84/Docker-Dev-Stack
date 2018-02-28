#!/bin/bash

EXECUTEDIR=$(pwd)
DOCKERFILE=""
DO_BUILD=false
DO_PUSH=false
DO_FORCED=false

if [ "$DOCKER_USERNAME" = "" ]; then
    DOCKER_USERNAME=bertoost
fi

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -f)
            DOCKERFILE=$1
            ;;
        --build)
            DO_BUILD=true
            ;;
        --push)
            DO_PUSH=true
            ;;
        --force)
            DO_FORCED=true
            ;;
        *)
            if [[ "$PARAM" == *"Dockerfile"* ]] || [ -d "$PARAM" ]; then
                DOCKERFILE=$PARAM
            else
                echo "ERROR: unknown parameter \"$PARAM\""
                exit 1
            fi
            ;;
    esac
    shift
done

if [ "$DOCKERFILE" = "" ]; then
  echo ""
  echo "No Dockerfile or path given! [required]"
  exit 1
fi

if [ "$DO_BUILD" = false ] && [ "$DO_PUSH" = false ]; then
  echo ""
  echo "At least one action is required! (--build | --push)"
  exit 1
fi

# !! DOCKERFILE PARSER FUNCTION !!
parse_dockerfile()
{
    DOCKERFILE=$1

    DIR=$(dirname "${DOCKERFILE}")
    cd $DIR

    DOCKERFILE_RELATIVE=$(basename "${DOCKERFILE}")

    IMAGENAME=$(cut -d/ -f2 <<< "${DOCKERFILE}")
    IMAGENAME="$DOCKER_USERNAME/$IMAGENAME"

    TAG=$(cut -d/ -f3 <<< "${DOCKERFILE}")
    TAG=$(echo ${TAG} | sed -e "s/Dockerfile\.//g")
    TAG=$(echo ${TAG} | sed -e "s/\./-/g")
    if [[ "${TAG}" = "Dockerfile" ]]; then
        TAG="latest"
    fi

    echo "Preparing $IMAGENAME:$TAG ..."

    if [ "$DO_BUILD" = true ]; then
        # pull before build to grab some cache
        docker pull "${IMAGENAME}:${TAG}"
        docker build -f "${DOCKERFILE_RELATIVE}" -t "${IMAGENAME}:${TAG}" .
    fi

    if [ "$DO_PUSH" = true ]; then
        docker push "${IMAGENAME}:${TAG}"
    fi

    cd $EXECUTEDIR

    echo ""
    echo "------------------------"
    echo ""
}

# When DOCKERFILE is a directory, scan it for all Dockerfile's
if [ -d $DOCKERFILE ]; then

    FILES="$DOCKERFILE/*"
    for FILE in $FILES
    do
        FILEBASE=$(basename $FILE)
        if [[ $FILEBASE == Dockerfile* ]]; then

            if [ "$DO_FORCED" = true ]; then
                parse_dockerfile $FILE
            else
                read -p "Do you want to parse ${FILEBASE} (Y/n)?" COND
                if [ "$COND" = "y" ] || [ "$COND" = "" ]; then
                    parse_dockerfile $FILE
                fi
            fi
        fi
    done
else
    if [ ! -f $DOCKERFILE ]; then
        echo "DockerFile not found!"
        echo 'Select a correct Dockerfile to build'
        exit 0
    fi

    parse_dockerfile $DOCKERFILE
fi