## Day 4 - YAML to K8s Object 

### What happens When ....

When you run the below commands:

`kubectl apply -f pod.yaml`

What actually happens after that? Underneath how the defined manifest in file `pod.yaml` creates and start the pod.

Let walk through the journey step by step from YAML manifest to running a container.

### **Step 1:** Your YAML hits the API Server


```YAML

USER Submits the manifest ---> API Server  ---> etcd stores state

```

Your Pod definition is sent to API Server which is front door of your cluster.

The API Server:

- Validates the YAML (checks syntax, required fields, etc.)
- Returns an error if anything is invalid
- If valid, it moves forward

📌 All requests in Kubernetes go through the API Server.


### **Step 2:** API Server Stores It in etcd
 

Once validated, the API Server saves the desired state in the database:

      "A Pod named my-pod should exist in the cluster."

That database is called etcd — it stores the entire state of your cluster.


### **Step3:** Controller Notices Something’s Missing

The `Controller Manager` is always watching the cluster state.

It sees:

    “There’s a record in etcd saying this Pod should exist… but I don’t see it running.”

So, it triggers the next step: **Pod scheduling.**


### **Step 4:** Scheduler Picks the Best Node
 

The Scheduler kicks in. It checks:

- CPU/memory availability
- Node labels and affinity
- Taints and tolerations

Then it selects a Worker Node and tells the API Server to bind the Pod to that Node.

📌 Remember: the Scheduler doesn’t create Pods — it just assigns them.

### **Step 5:** Kubelet on the Node Start to work

Now, Kubelet of the node will start to perform below actions:

  - Pulls container image using `containerd`.
  - Starts the container
  - Monitors the health of pod

If anything goes wrong(i.e image not found) kubelet reports it.


### **Step 5:** Pod is running

- You can check the pod is running.

  ` kubectl get pods`

