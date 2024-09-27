
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

2. 


### Desventajas

1. Si se quiere deployar bastantes funciones por algun cambio global sera pesado para el actions.