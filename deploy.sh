#!/bin/bash
echo "Deployment started ..."

# Change to the project directory
cd $3

# Pull the latest version of the app
#git pull --username zack965 --token $GIT_TOKEN

git pull https://$1:$2@github.com/$4


echo "Deployment ended ..."

