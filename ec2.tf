module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  for_each = toset(["server", "managed-node"])

  name = "${var.name_prefix}-${each.key}"

  instance_type               = "t3.micro"
  key_name                    = "tk-ec2-keypair"
  monitoring                  = true
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  create_security_group       = false
  vpc_security_group_ids      = [module.security_group.id]

# Inject keys using standard base64 encoding to prevent cloud-init parse errors
  user_data_base64 = base64encode(
    each.key == "server" ? (
      <<-EOF
      #!/bin/bash
      set -ex
      
      USER_DIR="/home/ec2-user/.ssh"
      mkdir -p $USER_DIR

      # 1. Write the GENERATED PRIVATE key to server
      cat <<'KEY' > $USER_DIR/id_rsa
      ${tls_private_key.ssh_key.private_key_pem}
      KEY

      # 2. Disable host checking for easy SSH to managed node
      cat <<'CONFIG' > $USER_DIR/config
      Host *
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
      CONFIG

      # Set strict permissions
      chmod 600 $USER_DIR/id_rsa
      chmod 600 $USER_DIR/config
      chown -R ec2-user:ec2-user $USER_DIR
      EOF
    ) : (
      <<-EOF
      #!/bin/bash
      set -ex

      USER_DIR="/home/ec2-user/.ssh"
      mkdir -p $USER_DIR

      # Append the GENERATED PUBLIC key to managed node authorized_keys
      cat <<'KEY' >> $USER_DIR/authorized_keys
      ${tls_private_key.ssh_key.public_key_openssh}
      KEY

      # Set strict permissions
      chmod 600 $USER_DIR/authorized_keys
      chown -R ec2-user:ec2-user $USER_DIR
      EOF
    )
  )

  tags = {
    Terraform   = "true"
    Environment = "tk-test"
  }
}