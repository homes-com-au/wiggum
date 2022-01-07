#!/bin/bash

# Wiggum Bootstrap
# ================
# A lightweight DevOps linter
# This script will execute locally and fetch and run the latest version

echo "Checking latest version of Wiggum..."
WIGGUM_VERSION=`curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/latest`

echo "Fetching version ${WIGGUM_VERSION}..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/${WIGGUM_VERSION}/wiggum.sh)"
