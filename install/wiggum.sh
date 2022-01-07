#!/bin/bash

# Wiggum Bootstrap
# ================
# A lightweight DevOps linter
# This script will execute locally and fetch and run the latest version

echo "Checking latest version of Wiggum..."
VERSION_LATEST=`curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/latest`

echo "Fetching version ${VERSION_LATEST}..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/${VERSION_LATEST}/wiggum.sh)"
