## Strategy

`.spec.strategy` specifies the strategy used to replace old pods with new ones. `.spec.strategy.type` can be **RollingUpdate** or **Recreate**. RollingUpdate is the default one.

- **RollingUpdate:** Replaces old pods running the old version of the application with the  new version, one by one, without taking the cluster down.

- The deployments update pod in rolling update fashion when `.spec.strategy.type=RollingUpdate.`
  

   ```bash
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: rolling-update-example
      labels:
        app: frontend
        environment: production
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: frontend
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxSurge: 1
          maxUnavailable: 0
      template:
        metadata:
          labels:
            app: frontend
        spec:
          containers:
          - name: nginx
            image: nginx:1.23.4
            readinessProbe:
              httpGet:
                path: /
                port: 80

   ```

   - `spec.selector.matchLables` , `.spec.template.metadata.labels` must be added before creating any pod.
 
       ```bash

      controlplane ~/deployment ➜  kubectl apply -f rollingupdate.yaml 
      deployment.apps/rolling-update-example created
      
      controlplane ~/deployment ➜  
      
      controlplane ~/deployment ➜  kubectl get deployment
      NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
      rolling-update-example   3/3     3            3           9s
      
      controlplane ~/deployment ➜  kubectl get replicaset
      NAME                                DESIRED   CURRENT   READY   AGE
      rolling-update-example-75cb644d55   3         3         3       18s
      
      controlplane ~/deployment ➜  kubectl get pod
      NAME                                      READY   STATUS    RESTARTS   AGE
      rolling-update-example-75cb644d55-jcw5f   1/1     Running   0          24s
      rolling-update-example-75cb644d55-kfp22   1/1     Running   0          24s
      rolling-update-example-75cb644d55-n4v62   1/1     Running   0          24s

       ```

- **Recreate:** All existing pods are killed before new ones are created when .spec.strategy.type=Recreate

   ```bash
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: rolling-update-example
      labels:
        app: frontend
        environment: production
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: frontend
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxSurge: 1
          maxUnavailable: 0
      template:
        metadata:
          labels:
            app: frontend
        spec:
          containers:
          - name: nginx
            image: nginx:1.23.4
            readinessProbe:
              httpGet:
                path: /
                port: 80
   
   ```

