# terraform

Minimal demo for terraform using one "workspace" per environment and AWS S3 bucket for storing the state.
Each environment has its own properties file (*.tfvars) and a global (terraform.tfvars) for default values.
Secrets are encrypted with RSA keypair and the private key should not be commited to git.
One terraform "module" is defined for re-usable setup and then used from the main terraform file.


## setup

    terraform init

It will download the providers and create a lock file for the setup.


To create the resources defined in storage.tf for env 'stage14' run:

    terraform workspace new stage14
    terraform apply -var-file=env/$(terraform workspace show).tfvars


To format and validate the terraform file

    terraform fmt
    terraform validate


Inspect the current state using

    terraform show


Use the list subcommand to list of the resources in your project's state.

    terraform state list



## Protecting secrets
Generate RSA key pair but do not check-in the keypair.pem file to Git.

    openssl genrsa -out keypair.pem 2048
    openssl rsa -in keypair.pem -pubout -out publickey.pem

Encrypt and base64 encode the secret 'my-secret' using the public key and then you need to save it in the env's terraform.tfstate file.

    echo -n 'my-secret' | openssl rsautl -encrypt -pubin -inkey publickey.pem | base64

The the built in function for decrypting can be used. E.g.

    rsadecrypt(var.access_token, file("keypair.pem"))

Also add 'sensitive = true' to all variable declarations.

But the tfstate file will contain the secret in plain text so it is then stored in an AWS S3 bucket.

