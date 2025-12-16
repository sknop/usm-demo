# Lab 2

## Set up the schema registry link and exporter

### Schema registry URL and credentials

### Schema password secret

### Cluster with schema registry link

### Set up the exporter

[Schema exporter in Kubernetes](https://docs.confluent.io/operator/current/co-schema-registry-switchover.html?session_ref=direct&url_ref=https%3A%2F%2Fdocs.confluent.io%2Fplatform%2Fcurrent%2Fusm%2Fusm-schema.html#set-up-a-schema-exporter)
### Set up the importer

[Schema importer in Kubernetes](https://docs.confluent.io/operator/current/co-schema-registry-switchover.html?session_ref=direct&url_ref=https%3A%2F%2Fdocs.confluent.io%2Fplatform%2Fcurrent%2Fusm%2Fusm-schema.html#set-up-a-schema-importer)

### Testing: create a Datagen connector using the schema registry

### Observe schema transfer and metrics

# Finally, cleanup

Whatever method you used to create your Kubernetes cluster, the deployment will consume resources and incure cost.
In the spirit of **#tasty-not-wasty**, please clean up your resources again once you are done with the labs:

    terraform destroy -auto-approve

This command will destroy any AWS resources you have created and also remove the registration of your platform cluster,
the schema registry and the environment in Confluent Cloud.
