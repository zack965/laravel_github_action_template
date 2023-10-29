#!/bin/bash

# $1 is Username_GITHUB ( your username in github )
# $2 is GITHUB_TOKEN ( your github token in github )
# $3 is Project Path in the server (ProjectPath)
# $4 is your uri of the repo of your project on github (GithubProjectUri)
echo "Deployment started ..."

# Change to the project directory
cd $3

# Pull the latest version of the app

git pull https://$1:$2@github.com/$4

echo "here you can execute any command based on your situation and what you wish to acomplish"
# composer install
# php artisan migrate
# php artisan test
echo "Deployment ended ..."

