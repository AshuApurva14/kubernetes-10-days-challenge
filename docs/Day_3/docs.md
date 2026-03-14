## Day 3 - Kubernetes Control Plane Components

### *Who actually runs the kubernetes?*

**Control plane** also known as brain of the kubernetes cluster.

## **What is the Control Plane?**
- It decides what runs where
- Monitors everything
- Responds if anything changes
- Stores the actual and desired state of the cluster.

**NOTE: When you type `kubectl` then you are talking to Control Plane**

### **Core Components**

***1. API Server:*** This is the front door of your cluster.Every `kubectl` command you run goes to `API Server`, then it validates processes and requests and store the desired state in `etcd`. It is a central communication hub.

---

***2. etcd:*** The Key-Value pair database of your cluster. It stores everything: current cluster state, secrets, configmaps, objects specs --- everything.

👉  You never interact with etcd directly. Only the API Server does.

---

***3. Schedular:*** Assigns pods to nodes based on constraints(Node rules, affinity rules) and resources(Based on available CPU, Memory etc.) It decides where new pods go, when new pods needs to be created. The Schedular picks the best node for it.

👉 The Scheduler doesn’t start Pods — it just assigns them.
The Node’s kubelet actually does the creation.

---

***4. Controller manager:*** It runs controllers to maintain desired state of the cluster. Keeps the state sync(By comparing the desired state with current state in etcd). If Pod crashes, then it notices and take action to replace it.

***Example:***  You want 3 Pods, but only 2 are running?
→ The Controller tells Kubernetes to create another Pod.

---

***5. Cloud Controller Manager (Optional):*** Cloud integration
Used in cloud environments like AWS, GCP, or Azure.
It can create Load Balancers, attach storage, and sync cloud metadata.

👉 Not needed for local clusters like minikube or kind.

---

