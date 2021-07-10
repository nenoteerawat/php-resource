#!/bin/bash

set -e
set -o pipefail

EC2_USER="ec2-user"
FRONTEND_IP="3.1.114.168"
BACKEND_IP="18.136.243.2"
EC2_KEY="keys/key-php-service-frontend"

TASK=$1
ARGS=${@:2}

help__deployFrontend="Frontend deploy application"
task_deployFrontend() {
    local APP_NAME="botman-web"
    local APP_ZIP_PATH="application/${APP_NAME}.zip"
    deploy_process ${EC2_USER} ${FRONTEND_IP} ${APP_NAME} ${APP_ZIP_PATH}
}

help__deployBackend="Backend deploy application"
task_deployBackend() {
    local APP_NAME="botman-engine"
    local APP_ZIP_PATH="application/${APP_NAME}.zip"
    deploy_process ${EC2_USER} ${BACKEND_IP} ${APP_NAME} ${APP_ZIP_PATH}
}

deploy_process() {
    local USER=$1
    local IP=$2
    local APP_NAME=$3
    local APP_ZIP_PATH=$4
    scp -i "${EC2_KEY}" -r ${APP_ZIP_PATH} ${USER}@${IP}:/tmp/src
    ssh -i "${EC2_KEY}" ${USER}@${IP} "
        unzip -o /tmp/src/${APP_NAME}.zip -d /tmp/src
        rm -rf /var/www/backup/*
        mkdir -p /var/www/backup && cp -r /var/www/html/ /var/www/backup/
        rm -rf /var/www/html/*
        mv /tmp/src/${APP_NAME}/* /var/www/html/
        rm -rf /tmp/src/*
    "
}

## main
list_all_helps() {
  compgen -v | egrep "^help__.*"
}

NEW_LINE=$'\n'
if type -t "task_$TASK" &>/dev/null; then
  task_$TASK $ARGS
else
  echo $TASK
  echo $(list_all_helps)
  echo "usage: $0 <task> [<..args>]"
  echo "task:"

  HELPS=""
  for help in $(list_all_helps)
  do

    HELPS="$HELPS    ${help/help__/} |-- ${!help}$NEW_LINE"
  done

  echo "$HELPS" | column -t -s "|"
  exit 1
fi
