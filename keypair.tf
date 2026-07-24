# 1. Generate SSH Key Pair inside Terraform
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Save Private Key to ~/.ssh/id_rsa_tk
resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = pathexpand("ssh/id_rsa_tk")
  file_permission = "0600"
}

# 3. Save Public Key to ~/.ssh/id_rsa_tk.pub
resource "local_file" "public_key" {
  content         = tls_private_key.ssh_key.public_key_openssh
  filename        = pathexpand("ssh/id_rsa_tk.pub")
  file_permission = "0644"
}