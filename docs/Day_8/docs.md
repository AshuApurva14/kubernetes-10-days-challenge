## Day 7 - Kubernetes ConfigMap, Secrets and Volumes

You’ve deployed your app using a Deployment. It scales, updates, and rolls back — awesome.
 

But here’s what it can’t do yet:

- Load configs from a file or environment variable
- Access secrets securely
- Store data between restarts

Let’s fix that with:

- **ConfigMaps**
- **Secrets**
- **Volumes**


### 1. ConfigMap - For Plain Configuration (Non-Sensitive Data)

A ConfigMap lets you:

- Key-Value pairs
- Enviornment Variables
- App settings and args

📌 It’s designed for non-sensitive data.

Example:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_MODE: "production"
  APP_PORT: "8080"

```

Use it in Pod like this:

```yaml
envFrom:
  - configMapRef:
      name: app-config

```

Now your app will receive APP_MODE and APP_PORT as environment variables.


### 2. Secret - For Sensitive Data

**Secrets** are like ConfigMap, but base64 encoded and encrypted.

Use them to store:

- Passwords
- API Tokens
- TLS Certificates

📌 You should never put sensitive info directly in Pod specs or container images.

Example:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  username: YWRtaW4=     # base64 for 'admin'
  password: cGFzc3dvcmQ= # base64 for 'password'

```
Use it in your pod like this:

```yaml
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-secret
        key: username
 
```

This injects the value without exposing it in plain YAML.

### 3. Volumes — For Persisting or Sharing Data
 

A Volume gives your containers access to storage.

Use Volumes to:

- Save data between Pod restarts
- Share files between containers
- Mount ConfigMaps and Secrets as files

Example: 

Mounting a ConfigMap as files

```yaml
volumes:
  - name: config-volume
    configMap:
      name: app-config
containers:
  - name: app
    volumeMounts:
      - name: config-volume
        mountPath: /etc/config
```

📌 Result: Each key in the ConfigMap becomes a file in /etc/config

### Common Volume Types

Volume Type	  Use Case
emptyDir	  Scratch space (reset on Pod restart)
hostPath	  Mounts a host node folder (use with care)
configMap	  Mounts config as files
secret	      Mounts secrets as files
persistentVolumeClaim	Durable disk (for databases, logs, etc.)