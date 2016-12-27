#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

roles_dir="$SCRIPT_DIR/roles"
roles_list=(`cat "$SCRIPT_DIR/roles.list"`)

git_url_matching="^((git|ssh|http(s)?)|(git@[\w\.]+))(:(//)?)"

if [ ! -d $roles_dir ]; then
  mkdir $roles_dir
fi
 
for role in "${roles_list[@]}"
do 
#  echo $role
  if [[ "$role" =~ $git_url_matching ]]; then
    echo "cloning role : $role ..."
    cd "$roles_dir" && git clone $role 
  fi 
done
