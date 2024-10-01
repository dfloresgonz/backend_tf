#!/bin/bash

SERVICE_FOLDER=$1 || exit 1;

cd ../../services/$SERVICE_FOLDER

directories=$(find . -maxdepth 1 -type d)
mkdir -p ../../infrastructure/services/$SERVICE_FOLDER/deploy

# Loop through each directory
for dir in $directories; do
  if [ "$dir" = "." ]; then
    continue
  fi
  
  dir_name=$(basename $dir)
  echo "Processing directory: $dir_name"

  yarn workspace $dir_name run build && yarn workspace $dir_name run package
  mv $dir_name/$dir_name.zip ../../infrastructure/services/$SERVICE_FOLDER/deploy/
done