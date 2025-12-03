# Complete USM demo

Usage:

Set up your AWS access in your local environment, so that the command

        aws sts get-caller-identity

Gives you a positive response.

Run 

        terraform init

to set up the resource providers.

Set up terraform.tfvars to your liking, then run the usual commands, but in two stages:

        terraform plan -target=aws_subnet.usm-private-subnet
        terraform apply -target=aws_subnet.usm-private-subnet

Once this has run through, you can deploy the full setup:

        terraform apply

Good luck!
