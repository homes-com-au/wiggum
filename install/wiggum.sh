#!/bin/bash

# Wiggum Bootstrap
# ================
# A lightweight DevOps linter
# This script will execute locally and fetch and run the latest version

set -e

source .wiggum

if [[ -z "${VERSION_OVERRIDE}" ]] || [[ "${VERSION_OVERRIDE}" == "latest" ]];
then
  echo "Checking latest version of Wiggum..."
  WIGGUM_VERSION=`curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/latest`
else
  echo "Wiggum is overriding your version to ${VERSION_OVERRIDE}"
  WIGGUM_VERSION=$VERSION_OVERRIDE
fi

echo "Fetching version ${WIGGUM_VERSION}..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/${WIGGUM_VERSION}/wiggum.sh)"
