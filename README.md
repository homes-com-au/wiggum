# Wiggum

A simple DevOps and consistency linter.

## Requirements

* `bash`
* `curl`

## Usage

### Installing into an existing code repository

    $ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/install.sh)"

The install script will add the following to your code repository:

* A configuration file at `./.wiggum`
* Add a step at the top of your Buildkite pipeline `./.buildkite/pipeline.yml` to run Wiggum

### Running Wiggum

    $ ./wiggum.sh

### Configuration

The Wiggum installation script will create Wiggum's configuration file which is expected to be found at `.wiggum`. If no configuration file is found or configuration flags are missing, Wiggum will run with default values.

Please see the `install/.wiggum` file for example configuration flags with further documentation.

## Versioning

The latest and default version of Wiggum is accessible from this repo in `version/latest/wiggum.sh`. A versioning system has been designed so that you can evolve and refactor your DevOps practices without breaking existing repositories. `latest` is a symlink to the most recent version.

If you update the `latest` Wiggum version, all repositories where Wiggum is installed will error if not compliant unless those repositories are pinned to a specific version.

To pin a repository to a specific Wiggum version, use the VERSION_OVERRIDE configuration option.

To create a new version (this example creates a v0002 from v0001, update the version numbers to suit your needs):

    $ cp -r version/0001 version/0002
    $ rm version/latest
    $ cd version && ln -s 0002 latest && cd ..

