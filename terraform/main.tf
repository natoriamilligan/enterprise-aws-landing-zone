module "banking_vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "10.10.0.0/16"

  public_subnet_a = "10.10.1.0/24"
  public_subnet_b = "10.10.2.0/24"

  private_subnet_a = "10.10.101.0/24"
  private_subnet_b = "10.10.102.0/24"

  subnet_az_a = "us-east-1a"
  subnet_az_b = "us-east-1b"
}

module "payments_vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = "10.20.0.0/16"

  public_subnet_a = "10.20.1.0/24"
  public_subnet_b = "10.20.2.0/24"

  private_subnet_a = "10.20.101.0/24"
  private_subnet_b = "10.20.102.0/24"

  subnet_az_a = "us-east-1a"
  subnet_az_b = "us-east-1b"
}
