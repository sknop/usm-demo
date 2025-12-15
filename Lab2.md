# Lab 2

## Set up the schema registry link and exporter

### Schema registry URL and credentials

### Schema password secret

### Cluster with schema registry link

### Set up exporter

### Testing: create a Datagen connector using the schema registry

### Observe schema transfer and metrics

# Finally, cleanup

Whatever method you used to create your Kubernetes cluster, the deployment will consume resources and incure cost.
In the spirit of **#tasty-not-wasty**, please clean up your resources again once you are done with the labs:

    terraform destroy -auto-approve

This command will destroy any AWS resources you have created and also remove the registration of your platform cluster,
the schema registry and the environment in Confluent Cloud.
