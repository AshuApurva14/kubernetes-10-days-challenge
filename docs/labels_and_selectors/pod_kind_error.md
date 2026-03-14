## Pod Kind error

### Incorrect Manifest

```yaml
# pod.yaml

apiVersion: v1
kind: pod  # instead `Pod`
metadata:
  name: nginx-pod
  labels:
    app: web
spec:
  containers:
    - name: nginx
      image: nginx:1.14.2
      ports:
        - containerPort: 80


```

## Error 

```bash

kubectl apply -f pod.yaml 
Error from server (BadRequest): error when creating "pod_redis.yaml": pod in version "v1" cannot be handled as a Pod: no kind "pod" is registered for version "v1" in scheme "k8s.io/apimachinery@v1.29.0-k3s1/pkg/runtime/scheme.go:100

```
