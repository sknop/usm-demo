# Complete USM demo

Usage:

Set up your AWS access in your local environment, so that the command

    aws sts get-caller-identity

gives you a positive response. For most users within Confluent, do this by running 

    assume 

or 

    assume <profile-name>

Run 

    terraform init

to set up the resource providers.

> ## ⚠️ CAVEAT: VPN (Twingate) usage ⚠️
> 
> ** You might need to enable Twingate to run the `assume` command so that you can download the configurations from the 
> GitHub account first. Once you have run `assume`, disable Twingate again.
> 
> The Terraform script will determine your external IP address and set the security group accordingly so that you
> can only access your cluster from your current location. The VPN will change your IP address to the outside world
> and hence confuse the script.
> 
> The Terraform script will output the ID of your security group (external-vpc-security-group-id) if you want to
> change the settings later, for example, if you want to rerun the workshop in a different location.**

Set up terraform.tfvars to your liking. There is a template called `terraform.tfvars.template` you can use by simply
copying it to `terraform.tfvars`. Adjust the region and your username. We use the username to provide unique names for 
the environment and service user within the Confluent Cloud.

Also adjust `bootcamp-key-name` to ensure it is unique within your AWS account. Do the same with the `usm-manager` 
for the Confluent Cloud if required.

Refer to [EKS](eks.tf) if you want to use an EKS cluster (which will take longer to set up).

### CCloud credentials

You need to define two environment variables in your shell

    export TF_VAR_confluent_api_key=<YOUR CCLOUD API Key>
    export TF_VAR_confluent_api_secret=<YOUR CCLOUD API Secret>

If you prefer, you can also set these variables in your `terraform.tvars` file:

    confluent_api_key = <YOUR CCLOUD API Key>
    confluent_api_secret = <YOUR CCLOUD API Secret>

### Start deployment via terraform

Once `terraform.tfvars` is set up, run the usual commands, but in two stages:

    terraform apply -target=aws_subnet.usm-private-subnet

Once this has run through, you can deploy the full setup:

    terraform apply

## Kubernetes setup

There are two alternative setups you can use, EKS or Kind on a single instance. Refer to [EKS](eks.tf) for details
on the EKS setup. 

### Kind setup

The Kind setup requires the installation of Docker, Kind itself and the usual tools like `kubectl` and `helm`.
To make this process simpler, we provide a script you need to run once to set up your jumphost.

After you run `terraform apply` successfully, it will print out the IP address of your jump host. We also generated
a private key associated with the jump host with a local file called `bootcamp.pem`. You can use this to connect 
to your jump host:

    ssh -i bootcamp.pem ubuntu@<JUMPHOST IP ADDRESS>

After verifying that you can connect, return to your local machine and upload the setup script and all yaml files, for example:

    scp -i bootcamp.pem kind/* *.yaml *.txt ubuntu@<JUMPHOST IP ADDRESS>:   # do not forget the colon

Log back into your jumphost and run this script to complete the installation. You might have to change the permissions to be executable.

    chmod +x jumphost-setup.sh # optional
    ./jumphost-setup.sh 

*Log out and back in again* to complete the installation (change of hostname and adding the user to the docker group).

You are now ready to create the kind cluster:

    kind create cluster --config kind-config.yaml -n usm

This will take a few moments. After the creation is complete, follow the instructions to change the kubernetes context:

    kubectl cluster-info --context kind-usm

## General Kubernetes setup

The next steps are the same whether you are using EKS or Kind, 
just executed either on your local machine (EKS) or the jumphost (KIND).

### Install CFK (operator)

Create the `confluent` namespace and make it the default

    kubectl create namespace confluent
    kubens confluent

You can now install CFK via helm

    helm repo add confluentinc https://packages.confluent.io/helm
    helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace confluent

Use `kubectl get pods` to verify the operator is successfully deployed.

## Setup complete

Congratulations, you have a working Kubernetes environment ready to receive your cluster.

Have a notepad app or text editor handy, we will need to copy/paste a few details in a moment. 

Continue with [Lab 1](Lab1.md)
