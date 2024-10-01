#!/bin/bash

ENV=$1 || exit 1;
SERVICE=$2 || exit 1;
DOMINIO=$3 || exit 1;
TF_STATE_BUCKET=$4 || exit 1;

# Validate if $ENV is not local or remote
if [ "$ENV" != "local" ] && [ "$ENV" != "remote" ]; then
  echo "Invalid environment: $ENV. Must be 'local' or 'remote'."
  exit 1
fi

cd ../../infrastructure/services/$SERVICE

AWS_DEFAULT_REGION="us-east-2"
RUNTIME="nodejs20.x"
# TODO
USUARIO_BD="root"
API_KEY="1234567890"

echo "bucket = \"$TF_STATE_BUCKET\"" > backend.conf
echo "key = \"base.terraform.tfstate\"" >> backend.conf
echo "region = \"$AWS_DEFAULT_REGION\"" >> backend.conf

echo "region = \"$AWS_DEFAULT_REGION\"" > terraform.tfvars
echo "dominio = \"$DOMINIO\"" >> terraform.tfvars
echo "runtime = \"$RUNTIME\"" >> terraform.tfvars
echo "stage = \"$ENV\"" >> terraform.tfvars
echo "api_name = \"$SERVICE\"" >> terraform.tfvars
echo "USUARIO_BD = \"$USUARIO_BD\"" >> terraform.tfvars
echo "API_KEY = \"$API_KEY\"" >> terraform.tfvars

if [ $ENV == "remote" ]; then
    cp main-remote.tf main.tf

elif [ $ENV == "local" ]; then
    cp main-local.tf main.tf
fi

mv main-local.tf main-local.txt
mv main-remote.tf main-remote.txt

terraform init -backend-config=backend.conf
terraform apply -var-file="terraform.tfvars" -auto-approve -input=false

rm -f backend.conf terraform.tfvars main.tf
mv main-local.txt main-local.tf
mv main-remote.txt main-remote.tf