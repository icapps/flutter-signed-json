#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

file="config/remote_config.json"
outputFile="config/remote_config.enc"
echo "Encrypt $file to $outputFile"
dart pub global run sign_config encrypt -i $file -o $outputFile -e config/keys/encrypt.jwk
