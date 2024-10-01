#!/bin/bash

ENV=$1 || exit 1;
DOMINIO=$2 || exit 1;
TF_STATE_BUCKET=$3 || exit 1;

cd ../../infrastructure/resources/base

AWS_DEFAULT_REGION="us-east-2"

echo "bucket = \"$TF_STATE_BUCKET\"" > backend.conf
echo "key = \"base.terraform.tfstate\"" >> backend.conf
echo "region = \"$AWS_DEFAULT_REGION\"" >> backend.conf

echo "region = \"$AWS_DEFAULT_REGION\"" > terraform.tfvars
echo "dominio = \"$DOMINIO\"" >> terraform.tfvars
echo "tfstate_bucket = \"$TF_STATE_BUCKET\"" >> terraform.tfvars
echo "stage = \"$ENV\"" >> terraform.tfvars

if [ $ENV == "remote" ]; then
    cp main-remote.tf main.tf
    terraform init -backend-config=backend.conf
    terraform apply -var-file="terraform.tfvars" -auto-approve -input=false

elif [ $ENV == "local" ]; then
    cp main-local.tf main.tf
    mv main-local.tf main-local.txt
    mv main-remote.tf main-remote.txt
    terraform init -backend-config=backend.conf
    terraform apply -var-file="terraform.tfvars" -auto-approve -input=false
    rm -f backend.conf terraform.tfvars main.tf
    mv main-local.txt main-local.tf
    mv main-remote.txt main-remote.tf
else
    echo "Specify environment: 'local' or 'remote'"
fi