#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

file="config/remote_config.json"
outputFile="config/remote_config.signed"
echo "Signing $file to $outputFile"
dart pub global run sign_config sign -i $file -o $outputFile -s config/keys/sign.jwk
