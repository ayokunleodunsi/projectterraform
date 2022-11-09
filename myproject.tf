resource "aws_network_interface" "netcard_training" {
  subnet_id   = aws_subnet.main.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}
resource "aws_key_pair" "mainkey" {
        key_name = "id_rsa"
        public_key = file("/home/ayoadmin/.ssh/id_rsa.pub")

resource "aws_instance" "webserver_training" {
  ami           = "ami-09d3b3274b6c5d4aa" # us-east-1
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.mainkey.key_name}"

  network_interface {
    network_interface_id = aws_network_interface.netcard_training.id
    device_index         = 0
  }

  tags = {
    Name = "webserver_1"
  }
}