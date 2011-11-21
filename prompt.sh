#!/bin/sh

echo "Please input your user name for Git configuration (ex. Joseph Chiang): "
read user_name
git config -g user.name $user_name
echo "Please input your email for Git configuration (ex. joseph_chiang@miiicasa.com): "
read user_email
git config -g user.email $user_email
