# My docker image tools

Build:
```
docker build -t docker-my-tools .
```

Create the tag:
```
docker tag docker-my-tools:latest docker.io/diogopms/docker-my-tools:latest
```

Push:
```
docker push docker.io/diogopms/docker-my-tools:latest
```

## Kubernetes

```
kubectl run internal-tools --restart='Never' -i --tty --image diogopms/docker-my-tools -- bash
```

```
kubectl create -f pod.yaml
```

```
kubectl exec -it diogopms-my-tools bash
```
