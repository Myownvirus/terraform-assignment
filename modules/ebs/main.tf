resource "aws_ebs_volume" "this" {
  availability_zone = var.az
  size              = 8
  encrypted         = true
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.this.id
  instance_id = var.instance_id
}

