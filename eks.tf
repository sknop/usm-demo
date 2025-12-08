locals {
  kubernetes_version =  "1.34"
  cluster_name = "usm"
}

module "eks"  {
  count = var.enable_eks ? 1 : 0

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name = local.cluster_name
  kubernetes_version = local.kubernetes_version

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

data "aws_eks_addon_version" "ebs_csi" {
  most_recent = true
  addon_name  = "aws-ebs-csi-driver"
  kubernetes_version =  local.kubernetes_version
}

data aws_caller_identity "current" { }

# Data source to generate the trust policy for the EKS Service Account
data "aws_iam_policy_document" "ebs_csi_driver_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      # Reference the OIDC Provider ARN output from the EKS module
      identifiers = [one(module.eks[*].oidc_provider_arn)]
    }

    condition {
      test     = "StringEquals"
      # Use the Cluster OIDC Issuer URL output and clean it up for the 'sub' condition
      variable = "${replace(one(module.eks[*].cluster_oidc_issuer_url), "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    condition {
      test     = "StringEquals"
      # Use the Cluster OIDC Issuer URL output and clean it up for the 'aud' condition
      variable = "${replace(one(module.eks[*].cluster_oidc_issuer_url), "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# IAM Role for the EBS CSI Driver
resource "aws_iam_role" "ebs_csi_driver_role" {
  name               = "EKS-${one(module.eks[*].cluster_id)}-EBS-CSI-Driver-Role"
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver_assume_role.json
}

# Attach the required AWS Managed Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ebs_csi_driver_attach" {
  role       = aws_iam_role.ebs_csi_driver_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverServiceRole"
}

# Configure the EBS CSI Driver add-on
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = one(module.eks[*].cluster_id)
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = data.aws_eks_addon_version.ebs_csi.version  # "v1.53.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn

  # CRITICAL: Wait for the IAM Role components and OIDC provider to be ready
  depends_on = [
    aws_iam_role.ebs_csi_driver_role,
    aws_iam_role_policy_attachment.ebs_csi_driver_attach,
    # This ensures the OIDC provider resource is created before using its ARN/URL
    module.eks[0].oidc_provider_arn
  ]
}
