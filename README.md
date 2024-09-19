
```bash
cd services/service1/functionA
yarn build && yarn package
```

```bash
cd ../../../infrastructure/service1
terraform apply --auto-approve
```