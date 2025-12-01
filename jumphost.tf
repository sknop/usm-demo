resource "aws_instance" "jumphost" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.jumphost-instance-type
  key_name          = aws_key_pair.bootcamp-key.key_name

  root_block_device {
    volume_size = 50
  }

  subnet_id = aws_subnet.usm-public-subnet[0].id
  vpc_security_group_ids = [aws_security_group.all-usm.id, aws_security_group.external-access.id]
  associate_public_ip_address = true

  tags = {
    Name        = "USM Jumphost ${var.username}"
    description = "Jumphost for Bootcamp - Managed by Terraform"
    Owner_Name  = var.owner_name
    Owner_Email = var.owner_email
    sshUser     = "ubuntu"
    region      = var.region

    cflt_environment = "devel"
    cflt_partition = "onprem"
    cflt_managed_by = "user"
    cflt_managed_id	= "sven"
    cflt_service = "CTG"
    cflt_keep_until  = formatdate("YYYY-MM-DD", timeadd(timestamp(),"8766h"))
  }

  volume_tags = {
    cflt_partition = "devel"
    cflt_managed_by	= "onprem"
    cflt_managed_id	= "user"
    cflt_service      = "sven"
    cflt_environment  = "CTG"
    cflt_keep_until   = formatdate("YYYY-MM-DD", timeadd(timestamp(),"8766h"))
  }

  lifecycle {
    prevent_destroy = var.prevent-destroy
  }
}
