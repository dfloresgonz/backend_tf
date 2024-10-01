
### Requerimientos

1. Yarn `npm install -g yarn`

2. Docker desktop

3. Terraform

4. Localstack

5. nodejs 20 (nvm)

---

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

### Desventajas

1. Si se quiere deployar bastantes funciones por algun cambio global sera pesado para el actions.

### git

```bash
git rm -r --cached . 
git add .
git commit -m ".gitignore is now working"
git push
```

### terraform-local

```bash
pip install terraform-local
```

### Comandos

```bash
cd .github/scripts

./build.local.sh service1

docker-compose up -d

./deploy.base.sh local decepticons.dev prueba-state-bucket

./deploy.service.sh local service1 decepticons.dev prueba-state-bucket

```

### Pendientes

1. correr en localstack todos los servicios
  - build todos servicios
  - deploy todos servicios

2. deploy.service.sh read env from terraform.tfvars local