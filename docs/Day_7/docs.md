## Day 7 - Kubernetes Deployments and ReplicaSet

*Till now we have launched Pods and exposed them  using Services. But here is the real world problem:*

- **What happens if a Pod crashes?**
- **What if you want 5 copies of the same app running?**
- **What if you need to update your app without downtime?**

That’s where `Deployments` and `ReplicaSets` come in.

---

### What is ReplicaSet ?

A ReplicaSet ensure correct number of `identical Pods` is always running.

- If a Pod crashes → a new one is created
- If you scale to more replicas → more Pods are created automatically.

Example:

```yaml
  replicas: 3
  selector:
    matchLabels:
      app: web
      env: dev

```
This tells kubernetes to keep 3 Pods running that match label `app=web`

📌 You rarely create ReplicaSets directly — you use a Deployment to do it.



### What is Deployment?

A **Deployment** is a higher-level object that manages ReplicaSets for you.

It can:

- Create and maintain ReplicaSets
- Handle rolling updates
- Perform version rollbacks
- Define how your app should run (via the Pod Template)

📌 Think of a Deployment as your app’s “control system.”

### Simple Deployment Example

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
        - name: nginx
          image: nginx:1.21
          ports:
            - containerPort: 80

```

This will:

 - Create a ReplicaSet with 3 Pods
- Run NGINX version 1.21

Ensure all Pods are labeled app=web

---

### What’s a Pod Template?

Inside the Deployment YAML, the template: section is your **Pod Template.**

It’s the **blueprint** used to create all future Pods in that Deployment.

If a Pod is restarted or recreated, it’s rebuilt based on this template.

### **What Happens When You Update the Image?**

Let’s say you update the image from nginx:1.21 to nginx:1.22.

You run:

```bash
kubectl apply -f web-deployment.yaml
```

Kubernetes will:

1. Launch new Pods with the new image
2. Wait for them to be healthy
3. Delete the old Pods
4. Complete the update — with zero downtime

### Want to Roll Back?
 

You can easily undo any update with:

```bash
kubectl rollout undo deployment web-deployment
```

📌 Kubernetes tracks deployment history, so you can revert anytime.


Useful Commands to Try

```bash
kubectl get deployments
kubectl describe deployment web-deployment
kubectl scale deployment web-deployment --replicas=5
kubectl rollout status deployment web-deployment
kubectl rollout undo deployment web-deployment
```
