#!/bin/bash
DOMAIN_NAME=$1

RESULT=$(aws apigateway get-domain-names --query "items[?domainName=='${DOMAIN_NAME}'] | [0].domainName" --output text)

if [ "$RESULT" == "None" ]; then
  echo "{\"exists\": false}"
else
  echo "{\"exists\": true}"
fi