
```bash
cd services/service1/functionA
yarn build && yarn package
```

```bash
cd ../../../infrastructure/service1
terraform apply --auto-approve
```

### Pendientes

1. creacion bucket backend desde aqui

2. el tfstate no este dentro de folders sino separado con punto.

3. codigo en s3

4. Cloudformation stack

5. Hostedzone / Apigateway

6. Usar typescript