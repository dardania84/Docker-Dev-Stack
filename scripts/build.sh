#!/bin/sh

DOCKERFILE=""
DO_BUILD=false
DO_PUSH=false

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
        *)
            if [[ $PARAM == *"Dockerfile"* ]] || [[ -d $PARAM ]]; then
                DOCKERFILE=$PARAM
            else
                echo "ERROR: unknown parameter \"$PARAM\""
                usage
                exit 1
            fi
            ;;
    esac
    shift
done

# !! DOCKERFILE PARSER FUNCTION !!
parse_dockerfile()
{
    DOCKERFILE=$1

    DIR=$(dirname "${DOCKERFILE}")
    cd $DIR

    DOCKERFILE_RELATIVE=$(basename "${DOCKERFILE}")

    IMAGENAME=$(cut -d/ -f2 <<< "${DOCKERFILE}")
    IMAGENAME="bertoost/$IMAGENAME"

    TAG=$(cut -d/ -f3 <<< "${DOCKERFILE}")
    TAG=$(echo ${TAG} | sed -e "s/Dockerfile\.//g")
    TAG=$(echo ${TAG} | sed -e "s/\./-/g")
    if [[ "${TAG}" = "Dockerfile" ]]; then
        TAG="latest"
    fi

    echo "Preparing $IMAGENAME:$TAG ..."

    if [[ "$DO_BUILD" = true ]]; then
        docker build -f "${DOCKERFILE_RELATIVE}" -t "${IMAGENAME}:${TAG}" .
    else
        echo "Skipped building image..."
    fi

    if [[ "$DO_PUSH" = true ]]; then
        docker push "${IMAGENAME}:${TAG}"
    else
        echo "Skipped pushing image..."
    fi

    echo ""
    echo "------------------------"
    echo ""
}

# When DOCKERFILE is a directory, scan it for all Dockerfile's
if [[ -d $DOCKERFILE ]]; then

    FILES="$DOCKERFILE/*"
    for FILE in $FILES
    do
        FILEBASE=$(basename $FILE)
        if [[ $FILEBASE =~ ^Dockerfile.* ]]; then

            read -p "Do you want to parse ${FILEBASE} (Y/n)?" COND
            if [ "$COND" = "y" ] || [ "$COND" = "" ]; then
                parse_dockerfile $FILE
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