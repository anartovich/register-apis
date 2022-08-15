#!/bin/bash

echo "#######"
echo "# $(tput setaf 5)MOCKING APIs OUTPUT"
echo "$(tput sgr0)#"
echo "# This script will start one docker mock server container per API in the APIs folder"
echo "$(tput sgr0)# Before continuing, make sure that your local repo clone is in sync with GitHub"
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
    echo $(cat $FILE_NAME | jq 'del(.components.securitySchemes)') > processed/$FILE_NAME
    docker run --init -d --rm -v $(pwd)/processed:/tmp -p $PORT:4010 stoplight/prism:4.10.1 mock -d -h 0.0.0.0 "/tmp/$FILE_NAME"
    (( PORT = PORT + 1 ))
done