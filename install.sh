#!/bin/bash

# Wiggum Installer
# ================
# A lightweight DevOps linter
# Installs Wiggum into your project

# This script is designed to be fetched from the repo that you want to install Wiggum into
# Refer to the README.md for more information
# Run this script from the root of your project:
#     $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/install.sh)"

set -e

error () {
  echo "$@" >&2
}

# Double check that we're not in the Wiggum repo
if [ "$(grep -c 'url = git@github.com:homes-com-au/wiggum.git' ./.git/config)" -ne "0" ];
then
  error "This script is not designed to run from the Wiggum repo. Please run it from the root of the project that you want Wiggum installed into."
  exit 1
fi

# Copy over the configuration file
if [ -f ".wiggum" ];
then
  error "A .wiggum file already exists. Maybe you've already installed Wiggum?"
  exit 1
fi
curl -o .wiggum https://raw.githubusercontent.com/homes-com-au/wiggum/master/install/.wiggum

# Copy over the bootstrap file
if [ -f "wiggum.sh" ];
then
  error "A wiggum.sh file already exists. Maybe you've already installed Wiggum?"
  exit 1
fi
curl -o wiggum.sh https://raw.githubusercontent.com/homes-com-au/wiggum/master/install/wiggum.sh
chmod +x wiggum.sh
