# EKS setup (optional)

The EKS is closer to a production environment, but requires more resources and takes longer
to set up (around 30 min). The EKS setup can also fail depending on your AWS account if the tagging policy is too
aggressive. We have provided tags for the EKS instances and storage, but in some accounts this does not seem
sufficient. If your deployment attempt fails with warnings that ProvisioningFailed, switch to the Kind setup.

Set up your Terraform environment and AWS access as described in the [README](README.md):

In the `terraform.tfvars` file, define this setting (false by default)

    enable_eks = true

You should also reduce the size of the jumphost that you will just use for verification purposes by setting, for example

    jumphost-instance-type = "t3.small"

When using EKS, you can deploy to your Kubernetes cluster from your local machine. You will need to install
`kubectl` and `helm` to do so. We also advise to install `kubectx` and `kubens` and maybe even `k9s` if not already done.

You will also need the EKS Kubernetes context in your environment. Use this command for that purpose
(the EKS cluster name is `usm-<USERNAME>` by default):

    aws eks update-kubeconfig --name usm-<USERNAME> --region <YOUR-REGION>

The EKS deployment via Terraform is pretty complete, but it lacks the StorageClass setup. 

Create your Kubernetes namespace first, (usually `confluent`),  

    kubectl create namespace confluent
    kubens confluent # if you have kubens installed
    kubectl config set-context --current --namespace=confluent # without kubens

Then create your default storage class from `eks/storage.yaml` like so

    kubectl apply -f eks/storage.yaml

You can then deploy the CFK operator and your cluster as described in the [README](README.md).

