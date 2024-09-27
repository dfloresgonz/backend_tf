
```bash
cd services/service1/functionA
yarn build && yarn package
```

```bash
cd ../../../infrastructure/service1
terraform apply --auto-approve
```

Creacion inicial de base:
```bash
terraform init -backend-config=backend.conf
terraform apply -var="dominio=decepticons.dev" -var="region=us-east-2"
```

Creacion inicial de un servicio:
```bash
terraform init -backend-config=backend.conf

terraform apply -var="dominio=decepticons.dev" -var="region=us-east-2" -var="api_name=service1" -var="USUARIO_BD=softhy" -var="runtime=nodejs20.x" -var="stage=test"
```

### Pendientes

1. creacion bucket backend desde terraform (/resources/base)

2. deployar solo funciones

3. deploy.yml service

4. correr en localstack

5. redeployar aws_api_gateway_stage


### Desventajas

1. Si se quiere deployar bastantes funciones por algun cambio global sera pesado para el actions.

### git

```bash
git rm -r --cached . 
git add .
git commit -m ".gitignore is now working"
git push
```