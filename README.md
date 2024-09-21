
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

3. codigo de lambdas en s3

4. Cloudformation stack

5. Hostedzone / Apigateway

6. Usar typescript

7. Levantar en local

### Desventajas

1. Si se quiere deployar bastantes funciones por algun cambio global sera pesado para el actions.