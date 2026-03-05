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

- After applying the above manifest file

    ```bash

     controlplane ~ ➜  kubectl apply -f deployment.yaml 
   replicaset.apps/frontend created
   
   controlplane ~ ➜  kubectl get rs
   NAME       DESIRED   CURRENT   READY   AGE
   frontend   3         3         3       10s
   
   controlplane ~ ➜  kubectl get pods
   NAME             READY   STATUS    RESTARTS   AGE
   frontend-7hr42   1/1     Running   0          16s
   frontend-fmljl   1/1     Running   0          16s
   frontend-pqmj2   1/1     Running   0          16s
   
   controlplane ~ ➜  kubectl describe rs frontend
   Name:         frontend
   Namespace:    default
   Selector:     tier=frontend
   Labels:       <none>
   Annotations:  <none>
   Replicas:     3 current / 3 desired
   Pods Status:  3 Running / 0 Waiting / 0 Succeeded / 0 Failed
   Pod Template:
     Labels:  tier=frontend
     Containers:
      nginx-container:
       Image:         nginx:1.23
       Port:          80/TCP
       Host Port:     0/TCP
       Environment:   <none>
       Mounts:        <none>
     Volumes:         <none>
     Node-Selectors:  <none>
     Tolerations:     <none>
   Events:
     Type    Reason            Age   From                   Message
     ----    ------            ----  ----                   -------
     Normal  SuccessfulCreate  30s   replicaset-controller  Created pod: frontend-7hr42
     Normal  SuccessfulCreate  30s   replicaset-controller  Created pod: frontend-fmljl
     Normal  SuccessfulCreate  30s   replicaset-controller  Created pod: frontend-pqmj2
   
   controlplane ~ ➜  kubectl describe pod ^C
   
   controlplane ~ ✖ kubectl get pod frontend-7hr42 
   NAME             READY   STATUS    RESTARTS   AGE
   frontend-7hr42   1/1     Running   0          51s
   
   controlplane ~ ➜  kubectl describe pod frontend-7hr42 
   Name:             frontend-7hr42
   Namespace:        default
   Priority:         0
   Service Account:  default
   Node:             node02/192.168.84.203
   Start Time:       Thu, 05 Mar 2026 18:35:07 +0000
   Labels:           tier=frontend
   Annotations:      cni.projectcalico.org/containerID: 40a0b38582a0f87c8242e530afb4c112163a2309add83390122124635751f2af
                     cni.projectcalico.org/podIP: 172.17.2.2/32
                     cni.projectcalico.org/podIPs: 172.17.2.2/32
   Status:           Running
   IP:               172.17.2.2
   IPs:
     IP:           172.17.2.2
   Controlled By:  ReplicaSet/frontend
   Containers:
     nginx-container:
       Container ID:   containerd://8213df9ff581a24162bf1c4954ee5baf9802ec37a3771840ce8a0618f7430ef1
       Image:          nginx:1.23
       Image ID:       docker.io/library/nginx@sha256:f5747a42e3adcb3168049d63278d7251d91185bb5111d2563d58729a5c9179b0
       Port:           80/TCP
       Host Port:      0/TCP
       State:          Running
         Started:      Thu, 05 Mar 2026 18:35:14 +0000
       Ready:          True
       Restart Count:  0
       Environment:    <none>
       Mounts:
         /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-k7b7d (ro)
   Conditions:
     Type                        Status
     PodReadyToStartContainers   True 
     Initialized                 True 
     Ready                       True 
     ContainersReady             True 
     PodScheduled                True 
   Volumes:
     kube-api-access-k7b7d:
       Type:                    Projected (a volume that contains injected data from multiple sources)
       TokenExpirationSeconds:  3607
       ConfigMapName:           kube-root-ca.crt
       Optional:                false
       DownwardAPI:             true
   QoS Class:                   BestEffort
   Node-Selectors:              <none>
   Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                                node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
   Events:
     Type    Reason     Age   From               Message
     ----    ------     ----  ----               -------
     Normal  Scheduled  64s   default-scheduler  Successfully assigned default/frontend-7hr42 to node02
     Normal  Pulling    63s   kubelet            spec.containers{nginx-container}: Pulling image "nginx:1.23"
     Normal  Pulled     57s   kubelet            spec.containers{nginx-container}: Successfully pulled image "nginx:1.23" in 5.352s (5.352s including waiting). Image size: 57002949 bytes.
     Normal  Created    57s   kubelet            spec.containers{nginx-container}: Container created
     Normal  Started    57s   kubelet            spec.containers{nginx-container}: Container started
   
   controlplane ~ ➜  

    ```

