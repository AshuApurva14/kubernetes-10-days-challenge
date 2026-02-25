## Labels and Selectors in Kubernetes

**Labels** and **Selectors** are key-value pairs attached to k8s objects.

Kubernetes supports two types of Label selectors:

1. Equality-based
   - Three kinds of operators are admitted ( =,==,!=).
   - Example:
      ```bash
       environment = production
      tier != frontend
      ```
  
3. Set-based

   - Three kinds of operators are supported: in,notin and exists (only the key identifier).
   - Example:

     ```bash
      environment in (production, qa)
     tier notin (frontend, backend)
      partition
      !partition

     ```



Below are the real practical implementations of labels and selectors:


```bash
#pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: frontend
    environment: production
spec:
  containers:
  - name: nginx-container
    image: nginx:1.7.9
    ports:
    - containerPort: 80
```
-----

```bash
# pod2.yaml

apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod2
  labels:
    app: backend
    environment: production
spec:
  containers:
  - name: nginx-container
    image: nginx:1.7.9
    ports:
    - containerPort: 80

```
-----

```bash
controlplane /home/example ➜  vi pod.yaml 

controlplane /home/example ➜  kubectl apply -f pod.yaml 
pod/nginx-pod created

controlplane /home/example ➜  kubectl get  pods
NAME        READY   STATUS              RESTARTS   AGE
nginx-pod   0/1     ContainerCreating   0          6s

controlplane /home/example ➜  kubectl get  pods
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          9s

controlplane /home/example ➜  kubectl describe pod nginx-pod
Name:             nginx-pod
Namespace:        default
Priority:         0
Service Account:  default
Node:             node02/192.168.27.7
Start Time:       Wed, 25 Feb 2026 16:51:05 +0000
Labels:           app=frontend
                  environment=production
Annotations:      cni.projectcalico.org/containerID: 2f6cb7f9d8913d92e521f6ccda0301ed28b3e97b738f7b95fb07b1b7937152df
                  cni.projectcalico.org/podIP: 172.17.2.2/32
                  cni.projectcalico.org/podIPs: 172.17.2.2/32
Status:           Running
IP:               172.17.2.2
IPs:
  IP:  172.17.2.2
Containers:
  nginx-container:
    Container ID:   containerd://8e565200d6f99c009036e0d089a643b4ac2912dd775795351ee37aeb5c5b430a
    Image:          nginx:1.7.9
    Image ID:       sha256:35d28df486f6150fa3174367499d1eb01f22f5a410afe4b9581ac0e0e58b3eaf
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 25 Feb 2026 16:51:12 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-gdzg4 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-gdzg4:
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
  Normal  Scheduled  24s   default-scheduler  Successfully assigned default/nginx-pod to node02
  Normal  Pulling    23s   kubelet            spec.containers{nginx-container}: Pulling image "nginx:1.7.9"
  Normal  Pulled     17s   kubelet            spec.containers{nginx-container}: Successfully pulled image "nginx:1.7.9" in 6.341s (6.341s including waiting). Image size: 39947836 bytes.
  Normal  Created    17s   kubelet            spec.containers{nginx-container}: Container created
  Normal  Started    17s   kubelet            spec.containers{nginx-container}: Container started

controlplane /home/example ➜  kubectl get pod -l app=frontend 
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          96s

controlplane /home/example ➜  kubectl get pod -l app=frontend,environment=production
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          2m1s

controlplane /home/example ➜  vi pod2.yml

controlplane /home/example ➜  kubectl apply -f pod2.yml 
pod/nginx-pod2 created

controlplane /home/example ➜  kubectl get pod -l app=backend
NAME         READY   STATUS    RESTARTS   AGE
nginx-pod2   1/1     Running   0          14s

controlplane /home/example ➜  kubectl get pod -l app=backend,environment=production
NAME         READY   STATUS    RESTARTS   AGE
nginx-pod2   1/1     Running   0          27s

controlplane /home/example ➜  kubectl get pod -l environment=production
NAME         READY   STATUS    RESTARTS   AGE
nginx-pod    1/1     Running   0          4m6s
nginx-pod2   1/1     Running   0          44s

controlplane /home/example ➜  kubectl get pod -l 'environment in (production),app notin(frontend)'
NAME         READY   STATUS    RESTARTS   AGE
nginx-pod2   1/1     Running   0          106s

controlplane /home/example ➜  
```

