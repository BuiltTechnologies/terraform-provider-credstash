#!/bin/bash

set -eox pipefail


if [ -z "$OS" ]; then
  OS="$(uname | tr '[:upper:]' '[:lower:]')"
fi

if [ -z "$ARCH" ]; then
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
fi

VERSION=0.5.1
INSTALLPATH=~/.terraform.d/plugins/registry.terraform.io/terraform-mars/credstash/${VERSION}/${OS}_${ARCH}
mkdir -p $INSTALLPATH
curl "https://github.com/BuiltTechnologies/terraform-provider-credstash/releases/download/v${VERSION}/terraform-provider-credstash_v${VERSION}_${OS}_${ARCH}" -L --output $INSTALLPATH/terraform-provider-credstash_v${VERSION}
chmod +x $INSTALLPATH/terraform-provider-credstash_v$VERSION
# Legacy path
LEGACYINSTALLPATH=~/.terraform.d/plugins/${OS}_${ARCH}
mkdir -p $LEGACYINSTALLPATH
curl "https://github.com/BuiltTechnologies/terraform-provider-credstash/releases/download/v${VERSION}/terraform-provider-credstash_v${VERSION}_${OS}_${ARCH}" -L --output $LEGACYINSTALLPATH/terraform-provider-credstash_v${VERSION}
chmod +x $LEGACYINSTALLPATH/terraform-provider-credstash_v$VERSION