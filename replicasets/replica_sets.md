## ReplicaSets

**ReplicaSet** is a controller that ensures a specified number of identical pod replicas are running at all times.

- Its main purpose is to maintain application **Availability** and **Fault Tolerance** by automatically creating new pods to replace any that fail, crash, or are deleted.

**Key Features:**

- Self-Healing
- Scaling
- Label-Based Selection
- High Availability

- It is recommended using Deployments instead of directly using ReplicaSets, unless you require custom update orchestration or don't require updates at all.

- This actually means that you may never need to manipulate ReplicaSet objects: use a Deployment instead, and define your application in the spec section.

   ```yaml
   # Replicaset example
   
    apiVersion: apps/v1
    kind: ReplicaSet
    metadata:
      name: frontend
    spec:
      replicas: 3 # Desired number of pods
      selector:
        matchLabels:
          tier: frontend
      template:
        metadata:
          labels:
            tier: frontend
        spec:
          containers:
          - name: nginx-container
            image: nginx:1.23
            ports:
            - containerPort: 80

   ```

