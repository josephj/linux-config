#!/bin/sh

user_name=""
while [ "$user_name" == "" ]
do
    echo "Please input your user name for Git configuration (ex. Joseph Chiang): "
    read user_name
done
git config --global user.name "$user_name"

user_email=""
while [ "$user_email" == "" ]
do
    echo "Please input your email for Git configuration (ex. joseph_chiang@miiicasa.com): "
    read user_email
done
git config --global user.email "$user_email"