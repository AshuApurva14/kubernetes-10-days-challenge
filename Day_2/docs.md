

## Learn Kubernetes the Right Way --  Starting with the Basics

## Day 2


Before you dive into running commands or writing YAML, there are 5 core concepts you need to understand. These are the building blocks of every Kubernetes cluster.

### 1. Container
A container is and isolated environment that runs our application.

It includes:

  - The app binary
  - Dependencies
  - Runtime environment


Containers are managed by a container runtime most commonly containerd.

**Important:** Kubernetes doesn't manage containers directly.

   It manages Pods, which run containers.


   **Container**

   - App Binary
   - Libraries
   - Dependencies



### 2. Pod

 A Pod is the smallest deployable object in Kubernetes.

 Each Pod:

    - Contains at least one container
    - Shares an IP Address and port space.
    - Can be restarted or replaced automatically if it crashes.

  
   
   **POD**

   - container-1
   - container-2 (optional)


### 3. Node

 A Node is a physical or virtual machine that runs your Pods.
 Each Node includes:

   
  - A container runtime (like containerd)
  - A kubelet (agent that talks to the control plane)
  - a kube-proxy (manages network rules for Pods)


    Pods ruun on Nodes
    And Nodes are registered to a Cluster.



    [Node]

      - kubelet
      - kube-proxy
      - containerd
      - Pods
         - Pod 1
         - Pod 2


### 4. Cluster

  A Kubernetes Cluster is the full system made of 

  - One or more Control Plane Nodes(they manage the system)
  - One or more Worker Nodes (they run the apps)
  

 All the magic from creating Pods to scaling your app happens inside the cluster.



 [Kubernetes Cluster]

  - Control Plane [API Server, Scheduler, etc.]
  - Worker Nodes (each running multiple Pods)


### 5. kubectl

kubectl is your command-line-tool for talking to the cluster.

With kubectl, you can:


- View cluster status
- Create, update or delete resources
- Apply YAML configurations
- Debug what's going wrong


## Example commands:

``` bash
 kubectl get pods
 kubectl get all
 kubectl apply -f app.yaml
 kubectl describe pod <name>

```

