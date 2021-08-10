
resource "aws_instance" "app" {
  count                  = var.instance_count
  ami                    = var.instance_ami
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnets[count.index % 2]
  instance_type          = var.instance_type
  # key_name               = var.ssh_key_name

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_type = "gp2"
    volume_size = var.ebs_volume_size
  }

  tags = {
    Terraforming = "true"
    Name         = "${var.name}_${count.index}"
    Service      = var.service
    DatadogFlag  = var.name
  }
}

resource "aws_eip" "app" {
  count    = var.instance_count
  instance = element(aws_instance.app.*.id, count.index)
  vpc      = true
}