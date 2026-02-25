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

### Define a Service using Label Selector

Create a `service.yaml` and define a label selector for each of the pods.

```bash
# Service.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app-service
spec:
  selector:
    app: frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80

```

```bash
controlplane /home/example ➜  vi service.yaml

controlplane /home/example ➜  kubectl apply -f service.yaml 
service/nginx-service created

controlplane /home/example ➜  kubectl get svc
NAME            TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
kubernetes      ClusterIP   172.20.0.1      <none>        443/TCP   79m
nginx-service   ClusterIP   172.20.252.19   <none>        80/TCP    11s

controlplane /home/example ➜  kubectl get svc -l app=frontend
No resources found in default namespace.

controlplane /home/example ➜  vi service.yaml

controlplane /home/example ➜  kubectl get svc -l name=nginx-service
No resources found in default namespace.

controlplane /home/example ➜  kubectl get svc | grep nginx-service
nginx-service   ClusterIP   172.20.252.19   <none>        80/TCP    76s

controlplane /home/example ➜  kubectl describe svc nginx-service
Name:                     nginx-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=frontend
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       172.20.252.19
IPs:                      172.20.252.19
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
Endpoints:                172.17.2.2:80
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>

controlplane /home/example ➜  kubectl get pod -l app=frontend
NAME        READY   STATUS    RESTARTS   AGE
nginx-pod   1/1     Running   0          40m

controlplane /home/example ➜  kubectl logs nginx-pod

controlplane /home/example ➜  curl -v http://172.20.252.19 
*   Trying 172.20.252.19:80...
* Connected to 172.20.252.19 (172.20.252.19) port 80 (#0)
> GET / HTTP/1.1
> Host: 172.20.252.19
> User-Agent: curl/7.81.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.7.9
< Date: Wed, 25 Feb 2026 17:33:46 GMT
< Content-Type: text/html
< Content-Length: 612
< Last-Modified: Tue, 23 Dec 2014 16:25:09 GMT
< Connection: keep-alive
< ETag: "54999765-264"
< Accept-Ranges: bytes
< 
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
* Connection #0 to host 172.20.252.19 left intact

controlplane /home/example ➜  kubectl logs nginx-pod
172.17.0.0 - - [25/Feb/2026:17:33:46 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.81.0" "-"

controlplane /home/example ➜  vi service.yaml 

controlplane /home/example ➜  kubectl apply -f service.yaml 
service/nginx-service configured

controlplane /home/example ➜  kubectl get svc | grep nginx-service
nginx-service   ClusterIP   172.20.252.19   <none>        80/TCP    6m20s

controlplane /home/example ➜  kubectl describe svc nginx-service
Name:                     nginx-service
Namespace:                default
Labels:                   <none>
Annotations:              <none>
Selector:                 app=backend
Type:                     ClusterIP
IP Family Policy:         SingleStack
IP Families:              IPv4
IP:                       172.20.252.19
IPs:                      172.20.252.19
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
Endpoints:                172.17.1.2:80
Session Affinity:         None
Internal Traffic Policy:  Cluster
Events:                   <none>

controlplane /home/example ➜  kubectl get pod -l app=backend
NAME         READY   STATUS    RESTARTS   AGE
nginx-pod2   1/1     Running   0          40m

controlplane /home/example ➜  kubectl logs nginx-pod2

controlplane /home/example ➜  curl -v  http://172.20.252.19
*   Trying 172.20.252.19:80...
* Connected to 172.20.252.19 (172.20.252.19) port 80 (#0)
> GET / HTTP/1.1
> Host: 172.20.252.19
> User-Agent: curl/7.81.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.7.9
< Date: Wed, 25 Feb 2026 17:35:41 GMT
< Content-Type: text/html
< Content-Length: 612
< Last-Modified: Tue, 23 Dec 2014 16:25:09 GMT
< Connection: keep-alive
< ETag: "54999765-264"
< Accept-Ranges: bytes
< 
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
* Connection #0 to host 172.20.252.19 left intact

controlplane /home/example ➜  kubectl logs nginx-pod2
172.17.0.0 - - [25/Feb/2026:17:35:41 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.81.0" "-"

controlplane /home/example ➜  
```

