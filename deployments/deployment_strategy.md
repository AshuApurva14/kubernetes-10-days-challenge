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
        type: Recreate
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

- Update the image tag

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
        type: Recreate
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
            image: nginx:1.29-perl
            readinessProbe:
              httpGet:
                path: /
                port: 80
   
   ```

  ---

  ```bash

  controlplane /home/deployment ➜  kubectl apply -f deployment.yml 
  deployment.apps/recreate-update-example created
  
  controlplane /home/deployment ➜  kubectl get deployment
  NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
  recreate-update-example   3/3     3            3           8s
  
  controlplane /home/deployment ➜  kubectl get replicaset
  NAME                                 DESIRED   CURRENT   READY   AGE
  recreate-update-example-75cb644d55   3         3         3       19s
  
  controlplane /home/deployment ➜  kubectl get pods
  NAME                                       READY   STATUS    RESTARTS   AGE
  recreate-update-example-75cb644d55-8sjbg   1/1     Running   0          28s
  recreate-update-example-75cb644d55-9dvj9   1/1     Running   0          28s
  recreate-update-example-75cb644d55-g9hwn   1/1     Running   0          28s


  ```

  - After the changes applied to the deployment yaml file
 
    ```bash

      controlplane /home/deployment ➜  vi deployment.yml

      controlplane /home/deployment ➜  cat deployment.yml 
      apiVersion: apps/v1
      kind: Deployment
      metadata:
         name: recreate-update-example
         labels:
            app: frontend
            environment: production
      spec:
          replicas: 3
          selector:
              matchLabels:
                app: frontend
          strategy:
              type: Recreate
          template:
              metadata:
                labels:
                  app: frontend
              spec:
                containers:
                - name: nginx
                  image: nginx:1.29-perl
                  readinessProbe:
                    httpGet:
                      path: /
                      port: 80
      
      controlplane /home/deployment ➜  kubectl apply -f deployment.yml 
      deployment.apps/recreate-update-example configured
      
      controlplane /home/deployment ➜  kubectl get deployment
      NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
      recreate-update-example   0/3     3            0           4m54s
      
      controlplane /home/deployment ➜  kubectl get deployment
      NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
      recreate-update-example   3/3     3            3           4m58s
      
      controlplane /home/deployment ➜  kubectl get replicaset
      NAME                                 DESIRED   CURRENT   READY   AGE
      recreate-update-example-5b9879fbc7   3         3         3       16s
      recreate-update-example-75cb644d55   0         0         0       5m4s
      
      controlplane /home/deployment ➜  kubectl get replicaset
      NAME                                 DESIRED   CURRENT   READY   AGE
      recreate-update-example-5b9879fbc7   3         3         3       23s
      recreate-update-example-75cb644d55   0         0         0       5m11s
      
      controlplane /home/deployment ➜  kubectl get replicaset
      NAME                                 DESIRED   CURRENT   READY   AGE
      recreate-update-example-5b9879fbc7   3         3         3       32s
      recreate-update-example-75cb644d55   0         0         0       5m20s
      
      controlplane /home/deployment ➜  kubectl get pods
      NAME                                       READY   STATUS    RESTARTS   AGE
      recreate-update-example-5b9879fbc7-dgb55   1/1     Running   0          42s
      recreate-update-example-5b9879fbc7-thrd8   1/1     Running   0          42s
      recreate-update-example-5b9879fbc7-zdszx   1/1     Running   0          42s
      
      controlplane /home/deployment ➜  

    ```

    - Checking the rollout history of the deployment
   
        - Sometimes, you may want to rollback a Deployment; for example, when the Deployment is not stable, such as crash looping.

        - By default, all of the Deployment's rollout history is kept in the system so that you can rollback anytime you want (you can change that by modifying revision history limit).
     
        - First check the revisions of the deployment

       ```bash
        controlplane /home/deployment ➜  kubectl rollout status deployment
        deployment "recreate-update-example" successfully rolled out
        
        controlplane /home/deployment ➜  kubectl rollout history deployment
        deployment.apps/recreate-update-example 
        REVISION  CHANGE-CAUSE
        1         <none>
        2         <none>
        
        
        controlplane /home/deployment ➜  kubectl rollout history deployment/recreate-update-example --revision=2
        deployment.apps/recreate-update-example with revision #2
        Pod Template:
          Labels:       app=frontend
                pod-template-hash=5b9879fbc7
          Containers:
           nginx:
            Image:      nginx:1.29-perl
            Port:       <none>
            Host Port:  <none>
            Readiness:  http-get http://:80/ delay=0s timeout=1s period=10s #success=1 #failure=3
            Environment:        <none>
            Mounts:     <none>
          Volumes:      <none>
          Node-Selectors:       <none>
          Tolerations:  <none>
        
        
        controlplane /home/deployment ➜  kubectl rollout history deployment/recreate-update-example --revision=1
        deployment.apps/recreate-update-example with revision #1
        Pod Template:
          Labels:       app=frontend
                pod-template-hash=75cb644d55
          Containers:
           nginx:
            Image:      nginx:1.23.4
            Port:       <none>
            Host Port:  <none>
            Readiness:  http-get http://:80/ delay=0s timeout=1s period=10s #success=1 #failure=3
            Environment:        <none>
            Mounts:     <none>
          Volumes:      <none>
          Node-Selectors:       <none>
          Tolerations:  <none>
        
        
        controlplane /home/deployment ➜  

       ```


   - Rolling Back to a Previous Revision
 
     ```bash
      controlplane /home/deployment ➜  kubectl rollout undo deployment/recreate-update-example
      deployment.apps/recreate-update-example rolled back
      
      controlplane /home/deployment ➜  kubectl rollout history deployment
      deployment.apps/recreate-update-example 
      REVISION  CHANGE-CAUSE
      2         <none>
      3         <none>
      
      
      controlplane /home/deployment ➜  kubectl rollout history deployment/recreate-update-example --revision=2
      deployment.apps/recreate-update-example with revision #2
      Pod Template:
        Labels:       app=frontend
              pod-template-hash=5b9879fbc7
        Containers:
         nginx:
          Image:      nginx:1.29-perl
          Port:       <none>
          Host Port:  <none>
          Readiness:  http-get http://:80/ delay=0s timeout=1s period=10s #success=1 #failure=3
          Environment:        <none>
          Mounts:     <none>
        Volumes:      <none>
        Node-Selectors:       <none>
        Tolerations:  <none>
      
      
      controlplane /home/deployment ➜  kubectl rollout history deployment/recreate-update-example --revision=3
      deployment.apps/recreate-update-example with revision #3
      Pod Template:
        Labels:       app=frontend
              pod-template-hash=75cb644d55
        Containers:
         nginx:
          Image:      nginx:1.23.4
          Port:       <none>
          Host Port:  <none>
          Readiness:  http-get http://:80/ delay=0s timeout=1s period=10s #success=1 #failure=3
          Environment:        <none>
          Mounts:     <none>
        Volumes:      <none>
        Node-Selectors:       <none>
        Tolerations:  <none>
      
      
      controlplane /home/deployment ➜  

     ```

