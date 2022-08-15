#!/bin/bash

echo "#######"
echo "# $(tput setaf 5)MOCKING APIs OUTPUT"
echo "$(tput sgr0)#"
echo "# This script will start one docker mock server container per API in the APIs folder"
echo "# Before continuing, make sure that your local repo clone is in sync with GitHub"
echo "# $(tput setaf 4)IF THERE IS ANY RUNNING CONTAINER ON A TARGET PORT (STARTING FROM 4010), IT WILL BE STOPPED AND REMOVED"
echo "$(tput sgr0)# Press $(tput setaf 3)q $(tput sgr0)to terminate OR press any other key to continue..."
echo "$(tput sgr0)#"
echo "#######"
read -s -n1 ACTION

if [ "$ACTION" = "q" ] || [ "$ACTION" = "Q" ]; then
    exit 0;
fi

FILES=$(ls -S APIs/mocked/*.json)
PORT=4010

if [ ! -d "processed/APIs/mocked" ]; then
    mkdir -p processed/APIs/mocked
else
    rm processed/APIs/mocked/*
fi


for FILE_NAME in $FILES
do
    ID=$(docker ps --filter publish=$PORT -q)

    if [ $ID ]; then
       docker rm -f $ID
    fi
    echo $(cat $FILE_NAME | jq 'del(.components.securitySchemes)') > processed/$FILE_NAME
    docker run --init -d --rm -v $(pwd)/processed:/tmp -p $PORT:4010 stoplight/prism:4.10.1 mock -d -h 0.0.0.0 "/tmp/$FILE_NAME"
    (( PORT = PORT + 1 ))
done
