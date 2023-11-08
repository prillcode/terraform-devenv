# Gets latest Amazon 2023.2 Linux distribution (see "*" in filter)
data "aws_ami" "devtest_server_ami" {
  most_recent = true
  owners      = ["137112412989"] #Amazon Owner Id

  filter {
    name   = "name"
    values = ["al2023-ami-2023.2.*.1-kernel-6.1-x86_64"]
  }
}

