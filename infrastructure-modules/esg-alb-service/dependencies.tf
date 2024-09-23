# use the defualt VPC & subnet

data "aws_vpc" "default" {
  default = true

}

data "aws_subnet" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

}

data "aws_subnet" "default" {
  count = length(data.aws_subnet.default.ids)
  id    = [data.aws_subnet.default.ids[count.index]]
}


# Look UP the UBUNTO AMI ID

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

}


