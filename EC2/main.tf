provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "tls_private_key" "rsa" {
  count      = var.create_key_pair == "yes" ? 1 : 0
  algorithm  = "RSA"
  rsa_bits   = 4096
}

resource "aws_key_pair" "tf-key-pair" {
  count     = var.create_key_pair == "yes" ? 1 : 0
  key_name  = var.key_pair_name
  public_key = tls_private_key.rsa[count.index].public_key_openssh
}

resource "local_file" "tf-key" {
  count     = var.create_key_pair == "yes" ? 1 : 0
  content   = tls_private_key.rsa[count.index].private_key_pem
  filename  = "${var.key_pair_name}.pem"
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  name = "AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonEC2RoleforSSM" {
  name = "AmazonEC2RoleforSSM"
}

resource "aws_iam_role" "ssm_role" {
  count = var.create_iam_role == "yes" ? 1 : 0
  name  = var.iam_role

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ssm.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core_policy_attachment" {
  count      = var.create_iam_role == "yes" ? 1 : 0
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
  role       = aws_iam_role.ssm_role[count.index].name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  count      = var.create_iam_role == "yes" ? 1 : 0
  policy_arn = data.aws_iam_policy.AmazonEC2RoleforSSM.arn
  role       = aws_iam_role.ssm_role[count.index].name
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  count = var.create_iam_role == "yes" ? 1 : 0
  name  = "ssm-instance-profile-1"
  role  = aws_iam_role.ssm_role[count.index].name
}

resource "aws_security_group" "security_group" {
  name        = var.security_group_name
  description = "Security group for server ${var.instance_name}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.create_key_pair == "yes" ? aws_key_pair.tf-key-pair[0].key_name : var.key_pair_name
  iam_instance_profile   = var.create_iam_role == "yes" ? aws_iam_instance_profile.ssm_instance_profile[0].name : null
  vpc_security_group_ids = [aws_security_group.security_group.id]

  root_block_device {
    volume_size = var.volume_size
    volume_type = "gp2"
  }

  tags = {
    Name         = var.instance_name
    Project-Name = var.project_name
  }
}

resource "aws_eip" "eip" {
  count = var.elastic_ip == "yes" ? 1 : 0
  domain = "vpc"
}

resource "aws_eip_association" "eip_assoc" {
  count         = var.elastic_ip == "yes" ? 1 : 0
  instance_id   = aws_instance.instance.id
  allocation_id = aws_eip.eip[count.index].id
}
