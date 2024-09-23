#!/bin/bash
DOMAIN_NAME=$1

# Obtén el nombre del dominio usando AWS CLI
RESULT=$(aws apigateway get-domain-names --query "items[?domainName=='${DOMAIN_NAME}'] | [0].domainName" --output text)

# Si el resultado es "None", significa que no existe, de lo contrario, existe.
if [ "$RESULT" == "None" ] || [ -z "$RESULT" ]; then
  echo "{\"exists\": \"false\"}"
else
  echo "{\"exists\": \"true\"}"
fi