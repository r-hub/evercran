
# Before deployment

## Ingress controller

Typically, one needs an ingress controller. E.g. on AKS:
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

## TLS

Using https://cert-manager.io

```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.1/cert-manager.yaml
```
