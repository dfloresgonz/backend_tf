
```bash
cd services/service1/functionA
yarn build && yarn package
```

```bash
cd ../../../infrastructure/service1
terraform apply --auto-approve
```

### Pendientes

1. creacion bucket backend desde terraform

2. codigo de lambdas en s3

3. Cloudformation stack

4. Hostedzone / Apigateway

5. Usar typescript

### Desventajas

1. Si se quiere deployar bastantes funciones por algun cambio global sera pesado para el actions.