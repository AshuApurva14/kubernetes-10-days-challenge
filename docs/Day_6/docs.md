## Day 6 - Label, Selectors and Namespace

### How does Kubernetes keeps everything organised?

With three powerful concepts:

- `Labels`
- `Selectors`
- `Namespace`

Let's breakdown each one them

### 1. Labels - Add Meaning to your Objects

A `Label` is a simple `key-pair value` you can attach to any kubernetes object.

- Pods
- Services
- Deployments
- Nodes
- And more

Example:

```yaml
labels:
  app: web
  env: prod
```
This Pod is now tagged with two labels:
```yaml
app=web
env=prod
```

📌 Labels aren’t just for grouping — they’re the glue that ties Services to Pods, or filters resources with kubectl.

---

### 2. Selectors — Find Resources by Label
 

A selector tells Kubernetes:

    “Find me all objects that match these labels.”

This is how:

- Services find the correct Pods
- Deployments manage matching Pods
- You query things with kubectl

Example:
```yaml
selector:
  app: web
```
This matches any Pod with the label `app=web.`
 
Try this CLI command:

`kubectl get pods -l app=web`


---

### 3. Namespaces — Organize and Isolate
 

**A namespace is like a mini-cluster within your Kubernetes cluster.**

You can use them to:

- Group resources by project or environment
- Avoid name collisions
- Apply security boundaries
- Every object in Kubernetes exists inside a namespace — even if it’s the default one.
 
CLI examples:

- `kubectl get namespaces`   # See all namespaces  
- `kubectl get pods -n dev`  # See Pods in the dev namespace  
- `kubectl create namespace staging`  # Create a new namespace


📌 Some default namespaces:

- `default` – where most of your stuff goes
- `kube-system` – internal components
- `kube-public` – public info
- `kube-node-lease` – used for Node heartbeats

