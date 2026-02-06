resource "aws_key_pair" "this" {
  key_name   = "${var.name_prefix}-${var.key_name}"
  public_key = var.public_key

  tags = {
    Name = "${var.name_prefix}-${var.key_name}"
  }
}
