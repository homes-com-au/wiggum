# Wiggum

A simple DevOps and consistency linter.

## Requirements

* `bash`
* `curl`

## Usage

### Installing into an existing code repository

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/homes-com-au/wiggum/master/install.sh)"
```

The install script will add the following to your code repository:

* A configuration file at `./.wiggum`
* A Wiggum bootstrap file at `./wiggum.sh` that you will need to run to execute Wiggum

Once the installation has completed you can decide on how you'd like to run Wiggum. Some ideas are:

* Run it as a pre-commit Git hook
* Add it to your CI pipeline
* Run it manually as needed

or do all three!

At Homes.com.au we're running it by adding a "soft fail" step in our Buildkite pipeline, with notifications going to our engineering Slack channel. This means that builds will still pass overall if Wiggum fails, but we will be alerted when it does so that we can action fixes.

#### Buildkite Pipeline Example

```yml
steps:
  - label: ":lint-roller: Wiggum checks"
    key: "wiggum"
    depends_on: ~
    agents:
      queue: "ci"
    command: "./wiggum.sh"
    soft_fail:
      - exit_status: 1

  - depends_on: "wiggum"
    command: |
      if [ $(buildkite-agent step get "outcome" --step "wiggum") == "soft_failed" ]; then
      cat <<- YAML | buildkite-agent pipeline upload
      steps:
        - label: ":red_circle: Wiggum check failed!"
          command: "exit 1"
          soft_fail:
            - exit_status: 1
          notify:
            - slack:
                channels:
                  - "#team-dev"
                message: "Wiggum check has failed for ${BUILDKITE_PIPELINE_NAME}. Last commit from ${BUILDKITE_BUILD_AUTHOR}. Results available here ${BUILDKITE_BUILD_URL}."
      YAML
      fi
```

### Running Wiggum

```sh
./wiggum.sh
```

### Configuration

The Wiggum installation script will create Wiggum's configuration file which is expected to be found at `.wiggum`. If no configuration file is found or configuration flags are missing, Wiggum will run with default values.

Please see the `install/.wiggum` file for example configuration flags with further documentation.

## Versioning

The latest and default version of Wiggum is accessible from this repo in `version/latest/wiggum.sh`. A versioning system has been designed so that you can evolve and refactor your DevOps practices without breaking existing repositories. `latest` is a symlink to the most recent version.

If you update the `latest` Wiggum version, all repositories where Wiggum is installed will error if not compliant unless those repositories are pinned to a specific version.

To pin a repository to a specific Wiggum version, use the `VERSION_OVERRIDE` configuration option.

To create a new version (this example creates a `0002` from `0001`, update the version numbers to suit your needs):

```sh
$ cp -r version/0001 version/0002
$ rm version/latest
$ cd version && ln -s 0002 latest && cd ..
```

## License

GNU General Public License v3.0
