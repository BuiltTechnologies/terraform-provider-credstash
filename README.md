# Install to override terraform-mars

## Automatically find the OS and ARCH:

```sh
VERSION=0.5.1
OS="$(uname | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
INSTALLPATH=~/.terraform.d/plugins/registry.terraform.io/terraform-mars/credstash/${VERSION}/${OS}_${ARCH}
mkdir -p $INSTALLPATH
curl "https://github.com/BuiltTechnologies/terraform-provider-credstash/releases/download/v${VERSION}/terraform-provider-credstash_v${VERSION}_${OS}_${ARCH}" -L --output $INSTALLPATH/terraform-provider-credstash_v${VERSION}
chmod +x $INSTALLPATH/terraform-provider-credstash_v$VERSION
# Legacy path
LEGACYINSTALLPATH=~/.terraform.d/plugins/${OS}_${ARCH}
mkdir -p $LEGACYINSTALLPATH
curl "https://github.com/BuiltTechnologies/terraform-provider-credstash/releases/download/v${VERSION}/terraform-provider-credstash_v${VERSION}_${OS}_${ARCH}" -L --output $LEGACYINSTALLPATH/terraform-provider-credstash_v${VERSION}
chmod +x $LEGACYINSTALLPATH/terraform-provider-credstash_v$VERSION
```

## NOTE: If you're using the m1 mac it might be worth also installing amd64:

```sh
VERSION=0.5.1
OS="darwin"
ARCH="amd64"
INSTALLPATH=~/.terraform.d/plugins/registry.terraform.io/terraform-mars/credstash/${VERSION}/${OS}_${ARCH}
mkdir -p $INSTALLPATH
curl "https://github.com/BuiltTechnologies/terraform-provider-credstash/releases/download/v${VERSION}/terraform-provider-credstash_v${VERSION}_${OS}_${ARCH}" -L --output $INSTALLPATH/terraform-provider-credstash_v${VERSION}
chmod +x $INSTALLPATH/terraform-provider-credstash_v$VERSION
# Legacy path
LEGACYINSTALLPATH=~/.terraform.d/plugins/${OS}_${ARCH}
mkdir -p $LEGACYINSTALLPATH
curl "https://github.com/BuiltTechnologies/terraform-provider-credstash/releases/download/v${VERSION}/terraform-provider-credstash_v${VERSION}_${OS}_${ARCH}" -L --output $LEGACYINSTALLPATH/terraform-provider-credstash_v${VERSION}
chmod +x $LEGACYINSTALLPATH/terraform-provider-credstash_v$VERSION
```

NOTE: If you run into errors like the checksums don't match you might need to delete the `.terraform` folder and the `.terraform.lock.hcl` file

Your folder structure should look something like below:

```
nativ-database git:(zach-helm) tree ~/.terraform.d                                                    
/Users/zachary.blanton/.terraform.d
├── checkpoint_cache
├── checkpoint_signature
└── plugins
    ├── darwin_amd64
    │   └── terraform-provider-credstash_v0.5.1
    ├── darwin_arm64
    │   └── terraform-provider-credstash_v0.5.1
    ├── registry.terraform.io
    │   ├── hashicorp
    │   └── terraform-mars
    │       └── credstash
    │           └── 0.5.1
    │               ├── darwin_amd64
    │               │   └── terraform-provider-credstash_v0.5.1
    │               └── darwin_arm64
    │                   └── terraform-provider-credstash_v0.5.1
    └── terraform-provider-credstash_v0.5.0
```

# Terraform provider for credstash secrets

[![CircleCI](https://circleci.com/gh/sspinc/terraform-provider-credstash.svg?style=svg)](https://circleci.com/gh/sspinc/terraform-provider-credstash)

Read secrets stored with [credstash][credstash].

## Install

1. [Download the binary for your platform][provider_binary]
2. Create the terraform plugin directory

        $ mkdir ~/.terraform.d/plugins

3. Copy the provider binary to the terraform plugin directory

        $ cp /path/to/terraform-provider-credstash ~/.terraform.d/plugins/terraform-provider-credstash_v0.5.0

4. Profit

### From source

    $ git clone https://github.com/sspinc/terraform-provider-credstash.git
    $ cd /path/to/terraform-provider-credstash
    $ make install

## Usage

```hcl
provider "credstash" {
    table  = "credential-store"
    region = "us-east-1"
}

data "credstash_secret" "rds_password" {
    name = "rds_password"
}

data "credstash_secret" "my_secret" {
    name    = "some_secret"
    version = "0000000000000000001"
}

resource "aws_db_instance" "postgres" {
    password = "${data.credstash_secret.rds_password.value}"

    # other important attributes
}
```

You can override the table on a per data source basis:

```hcl
data "credstash_secret" "my_secret" {
    table   = "some_table"
    name    = "some_secret"
    version = "0000000000000000001"
}
```

## AWS credentials

AWS credentials are not directly set. Use one of the methods discussed
[here][awscred].

You can set a specific profile to use:

```hcl
provider "credstash" {
    region  = "us-east-1"
    profile = "my-profile"
}
```

## Development

For dependency management Go modules are used thus you will need go 1.11+

1. Clone the repo `git clone https://github.com/sspinc/terraform-provider-credstash.git`
2. Run `make test` to run all tests

## Contributing

1. Fork the project and clone it locally
2. Open a feature brach `git checkout -b my-awesome-feature`
3. Make your changes
4. Commit your changes
5. Push your changes
6. Open a pull request

[credstash]: https://github.com/fugue/credstash
[awscred]: https://github.com/aws/aws-sdk-go#configuring-credentials
[provider_binary]: https://github.com/sspinc/terraform-provider-credstash/releases/latest
