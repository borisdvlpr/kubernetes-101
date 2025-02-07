# Kubernetes 101

This repo provides a brief introduction to Kubernetes, from basic concepts and architecure to and deployment examples. Some information used for building this guide was taken from the offical [Kubernetes Documentation](https://kubernetes.io.docs) and from [Bogdan Stashchuk's Youtube Course on Kubernetes](https://www.youtube.com/watch?v=d6WC5n9G_sM).

To follow the full guide, the following dependencies should be installed:

- [Docker](https://docs.docker.com/manuals/)
- [kind](https://kind.sigs.k8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Building Blocks

According to the official documentation, Kubernetes "is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation". TL;DR: it's a container orchestration system that provides you a platform for running distributed systems in a resilient way. It supports deployment patterns, handles scaling and failover for your application, and much more. Amongst many things, Kubernetes allows:

- Automatic deployments
- Service discovery and load balancing
- Auto scaling
- Monitoring
- Self healing

Although Docker is the most used container runtime, Kubernetes also supports other container runtimes, such as [containerd](https://containerd.io/) or [CRI-O](https://cri-o.io/).

## Components and Architecture

![Kubernetes Components and Architecture](./assets/kubernetes-cluster-architecture.png "Kubernetes Components and Architecture")

When you deploy Kubernetes, you get a cluster. As we can see by the arcitecture diagram above, a Kubernetes cluster consists of a set of worker machines, called nodes, that run containerized applications, and a control plane, responsible for managing the worker nodes. Every cluster has at least one worker node. The worker node(s) host the pods that are the components of the application workload. The smallest unit on the Kubernetes terminology is the pod: a deployable functional unit, that can correspond to one (or more, although it’s usually one) container, allocated in a host. If there’s multiple containers, they can share resources. Pods can work together, in a unit called a service. Worker nodes consist on the following components:

- kubelet - responsible for anything running on a (worker) node. Registers the node by creating a Node Resource in the API Server. Monitors the API Server for pod's scheduled to that node. Starts/terminates the pod's  containers by interacting with the container runtime, according to the status reported by the API Server
- kube-proxy - assures clients can connect to the services defined through the API Server, by proxying (iptables based forwarding) flows to the service IP address and port, to the hosting pod
- container runtime (CRI) - responsible for executing the containers inside of each pod

The control plane manages the worker nodes and the pods in the cluster. In production environments, the control plane usually runs across multiple computers and a cluster usually runs multiple nodes, providing fault-tolerance and high availability. The following components make up the control plane:

- kube-api-server - provides a “Create-Read-Update-Delete” (CRUD) interface over a RESTFul API. All the other components of the Kubernetes system communicate through this entity. It provides with updates to the rest of entities in the control sub-system
- scheduler (kube-scheduler) - decides about pod allocation into cluster nodes, by means of updating pod definitions in API Server
- controller manager (kube-controller-manager) - forces convergence towards the defined-desired state of the system, by watching resources status and updating those resources through the kube-api-server. Hosts multiple controllers:
    - Replication Manager and Replica Set Controllers - assure the number of pod replicas defined along the cluster
    - Service Controller, Node Controller, Endpoint Controller, Namespace Controller, Job Controller...
- cloud-controller-manager - enables the link of the cluster into the cloud provider's API, and separates out the components that interact with that cloud platform from components that only interact with the cluster
- etcd - distributed key-value storage: stores info about all the objects in a Kubernetes system: services, pods, etc.

