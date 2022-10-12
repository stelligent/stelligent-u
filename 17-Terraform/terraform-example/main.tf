provider "aws" {
    region = "us-east-1"
    access_key = "AKIAUXAYGAARTYR6VMSI7C"
    secret_key = "gEefvzATtW+YvP4sxNbEy8HSfgn55EoitOlRyoUf7wE3M"

}

resource "aws_instance" "my_ec2_server" {
    ami =  "ami-026b57f3c383c2eec"
    instance_type = "t2.micro"
}
