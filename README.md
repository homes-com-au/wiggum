# Wiggum

A simple DevOps and consistency linter.

## Requirements

* `bash`
* `curl`

## Usage

### Installing into an existing code repository

`$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/install.sh)"`

The install script will add the following to your code repository:

* A configuration file at `./.wiggum`
* Add a Buildkite step to your `./.buildkite/pipeline.yml` to run Wiggum as the first step in your pipeline

### Configuration

The Wiggum installation script will create Wiggum's configuration file which is expected to be found at `.wiggum`.

Wiggum currently respects the following flags:

    VERSION_OVERRIDE=latest
    # allows you to pin your Wiggum compliance to a specific version
    # accepts a version number, eg: 1.0, 2.0, 2.1
    # default value = latest

    CHECK_README=true
    # accepts boolean values: true|false
    # default value = true

    CHECK_DOCKER=true
    # accepts boolean values: true|false
    # default value = true

    CHECK_TERRAFORM=true
    # accepts boolean values: true|false
    # default value = true

    CHECK_BUILDKITE=true
    # accepts boolean values: true|false
    # default value = true

    CHECK_TESTS=true
    # accepts boolean values: true|false
    # default value = true

    CHECK_DEPENDENCIES=true
    # accepts boolean values: true|false
    # default value = true


