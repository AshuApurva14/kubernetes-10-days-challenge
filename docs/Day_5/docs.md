## Day 5 - Kubernetes Services

**Your pod is running but.**


**How do other apps and users connect to it?**

A Service gives you a stable way to access Pods — even as those Pods get restarted, moved, or replaced.

**Why it’s needed:**

- Pods come and go.
- Their IPs change.
- But your users (or other Pods) need a reliable way to reach them.


### How Services Work (Plain Version)

 - You define a Service in YAML
 - It uses labels to select matching Pods
 - Kubernetes gives the Service a virtual IP
 - All traffic to that IP is routed to one of the Pods

Example:

Your my-service can route traffic to multiple Pods like Pod A, Pod B, and Pod C — as long as they share a label like `app=nginx`.

---


## 4 Types of Kubernetes Services:

**1. ClusterIP (default)**

- Accessible only within the cluster
- Perfect for: microservices talking to each other
- Example use case: Backend service talking to a database

`type: ClusterIP`

---

**2. NodePort:**

- Opens a port on every Node
- Accessible via <NodeIP>:<NodePort>
- Good for: quick testing or exposing simple apps externally

```bash
type: NodePort
ports:
  - port: 80
    nodePort: 30080
```

---

**3.LoadBalancer:**

- Creates an external IP using a cloud provider
- Good for: production use in cloud (AWS, GCP, Azure)
- Requires cloud setup

---


**4.ExternalName:**

- Maps a Service to an external DNS
- Doesn’t route traffic — just redirects to a hostname
- Good for: pointing to something like api.stripe.com

```bash

type: ExternalName
externalName: example.com

```

----


## Service Example

Here’s a basic Service that exposes NGINX Pods:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
  type: ClusterIP

```

👉 This will route traffic on port 80 to any Pod with app=nginx.

