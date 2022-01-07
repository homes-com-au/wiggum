#!/bin/bash

# Wiggum Bootstrap
# ================
# A lightweight DevOps linter
# This script will execute locally and fetch and run the latest version

echo "Fetching latest version of Wiggum..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/version/latest/wiggum.sh)"
