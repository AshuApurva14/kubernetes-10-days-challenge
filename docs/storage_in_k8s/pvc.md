## Persistent Volume Claim

PersistentVolumeClaim 

```yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: web-server-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi

```

