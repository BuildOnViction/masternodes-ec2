# Step-by-step to provision infrastructure of masternodes on AWS EC2

## Updating...

1. Preparation

- Download and install `terraform` following this [docs](https://www.terraform.io/intro/getting-started/install.html)

- Config your AWS credentials following this [docs](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html)

1. Configuration

Update `main.tfvars` file at below fields:

- "sshKeyName": specify your ssh key registered on AWS
- "privateKeyPath": path to the private ssh key on your machine
- "coinbasePrivateKeySun": private key of the SUN masternode
- "access_key": AWS access key ID
- "secret_key": AWS secret key

1. Initialization your terraform configuration

The first command to run for a new configuration -- or after checking out an existing configuration from version control -- is terraform init, which initializes various local settings and data that will be used by subsequent commands.

```
$ terraform init
Initializing the backend...
Initializing provider plugins...
- downloading plugin for provider "aws"...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 1.0"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your environment. If you forget, other
commands will detect it and remind you to do so if necessary.
```

1. Start up SUN masternode, which is included TomoMaster, TomoScan, Netstats

```
$ terraform plan
$ terraform apply
```

1. Start up other masternodes



## Bring down
```

```


## Vote for a masternode
