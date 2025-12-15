# Lab 1

## Deploy and configure the local cluster with USM

### Install the first cluster

There is a ready-made cluster for you using the file `cp.yaml` that can simply be deployed with `kubectl`:

    kubectl apply -f cp.yaml

This will take a few minutes to complete. You can use `k9s`, `kubectl get pods -w` or a similar method to watch the
cluster being deployed.

Once the deployment is complete, we need the cluster id. The easiest way to get to that information is to use
the Confluent Control Center. Make it accessible via

    kubectl port-forward --address 0.0.0.0 controlcenter-0 9021:9021

If you are using EKS, you can simply connect to the control center in your browser using

    http://localhost:9021

If you are using kind from your jumphost, you need to connect to the IP address of your jumphost instead.
You can find the IP address in the printout of `terraform output`.

    http://<IP-ADDRESS>:9021

The cluster id is located under cluster settings if you click on your `controlcenter.cluster` panel.
Copy and save that name somewhere, we will need it in a moment.

### Register platform cluster



#### Download the configuration

#### Observe the schema registry being created for you

### Register connect cluster

### Set up usm agent in your Kubernetes environment

### Create a topic and see it being observed in Confluent Cloud

# Continue with [Lab2](Lab2.md)

