module "eks"  {
  count = var.enable_eks ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name = "us"
  kubernetes_version = "1.34"

  # Optional
  endpoint_public_access = true
  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id = aws_vpc.vpc.id
  subnet_ids = aws_subnet.usm-private-subnet.*.id
  control_plane_subnet_ids = aws_subnet.usm-public-subnet.*.id

  tags = {
    cflt_environment = "devel"
    cflt_partition = "onprem"
    cflt_managed_by = "user"
    cflt_managed_id	= "sven"
    cflt_service = "CTG"
    cflt_keep_until  = formatdate("YYYY-MM-DD", timeadd(timestamp(),"8766h"))
  }

  # Enable IRSA (OIDC) - equivalent to iam.withOIDC: true
  enable_irsa = true

  eks_managed_node_groups = {
    usm_cluster = {
      name = "usm-group-1"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 5
      desired_size = 2

      iam = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }
    }
  }

  addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    vpc-cni                = {
      before_compute = true
    }
  }

}