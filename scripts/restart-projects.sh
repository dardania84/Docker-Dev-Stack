#!/usr/bin/env bash

#
# To use this file create a file in the root project folder and include this script
# Example:
#
#       #!/usr/bin/env bash
#
#       # Define your projects root folder
#       PROJECTROOT=../projects
#
#       source scripts/restart-projects.sh
#
#       restart_project project-folder
#
#       # run from sub-folder
#       restart_project _sub/project-folder
#
#       # run with custom given docker compose file
#       restart_project project-folder docker-compose-custom.yml
#
#       # run with custom given sh script
#       restart_project project-folder start.sh
#
# To only up or down projects, call your script like
#
#       sh restart_project.sh --down-only
#       sh restart_project.sh --up-only
#

UP_ONLY=false
DOWN_ONLY=false

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        --up-only)
            UP_ONLY=true
            ;;
        --down-only)
            DOWN_ONLY=true
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            usage
            exit 1
            ;;
    esac
    shift
done

function restart_project()
{
    PROJECTDIR="$PROJECTROOT/$1"
    ADDITIONAL_SCRIPT=$2
    SCRIPTDIR=$(pwd)

    cd $PROJECTDIR

    if [ "$ADDITIONAL_SCRIPT" != "" ]; then
        if [[ $ADDITIONAL_SCRIPT == *"yml" ]]; then
            if [ "$UP_ONLY" = true ]; then
                docker-compose -f $ADDITIONAL_SCRIPT pull
                docker-compose -f $ADDITIONAL_SCRIPT up -d
            elif [ "$DOWN_ONLY" = true ]; then
                docker-compose -f $ADDITIONAL_SCRIPT down --remove-orphans
            else
                docker-compose -f $ADDITIONAL_SCRIPT down --remove-orphans
                docker-compose -f $ADDITIONAL_SCRIPT pull
                docker-compose -f $ADDITIONAL_SCRIPT up -d
            fi
        else
            sh $ADDITIONAL_SCRIPT
        fi
    else
        if [ "$UP_ONLY" = true ]; then
            docker-compose pull
            docker-compose up -d
        elif [ "$DOWN_ONLY" = true ]; then
            docker-compose down --remove-orphans
        else
            docker-compose pull
            docker-compose down --remove-orphans
            docker-compose up -d
        fi
    fi

    cd $SCRIPTDIR
}