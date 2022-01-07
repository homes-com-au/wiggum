#!/bin/bash

# Wiggum
# ======
# A lightweight DevOps linter
# Checking for consistent DevOps patterns across codebases

set -e

echo "Wiggum is running..."
COLLECTED_ERRORS=()

# Check that certain files exist
FILES_SHOULD_EXIST=( README.md ./Dockerfile ./docker-compose.yml .dockerignore ./.buildkite/pipeline.yml )
for i in "${FILES_SHOULD_EXIST[@]}"
do
  if [ ! -f "$i" ];
  then
    COLLECTED_ERRORS+=("File $i does not exist")
  fi
done

# Check that certain directories exist
DIRS_SHOULD_EXIST=( ./terraform ./.buildkite )
for i in "${DIRS_SHOULD_EXIST[@]}"
do
  if [ ! -d "$i" ];
  then
    COLLECTED_ERRORS+=("Directory $i does not exist")
  fi
done


# Check that Dockerfiles are alpha sorted
if [ "$(ls *-Dockerfile 2> /dev/null | wc -l)" -ge "1" ];
then
  COLLECTED_ERRORS+=("Dockerfile naming convention should be 'Dockerfile' or 'Dockerfile-<env>'")
fi

# Check that there's a 'test' service in Docker Compose
if [ "$(grep -c '^  test:' ./docker-compose.yml)" -eq "0" ];
then
  COLLECTED_ERRORS+=("'test:' service not found in docker-compose.yml")
fi

# Check that there's a 'test' step in BuildKite
if [ "$(grep -c "^    key: 'test'" ./.buildkite/pipeline.yml)" -eq "0" ];
then
  COLLECTED_ERRORS+=("Key marked 'test' not found in ./.buildkite/pipeline.yml")
fi

# Check that Wiggum runs in Buildkite pipeline
if [ "$(grep -c "wiggum.sh" ./.buildkite/pipeline.yml)" -eq "0" ];
then
  COLLECTED_ERRORS+=("Wiggum not found in ./.buildkite/pipeline.yml")
fi

# Check that there's a .git entry in .dockerignore
if [ "$(grep -c '.git' ./.dockerignore)" -eq "0" ];
then
  COLLECTED_ERRORS+=("'.git' not found in ./.dockerignore")
fi

# Check that the terraform plugin is not being used in Buildkite pipeline
if [ "$(grep -c 'echoboomer/terraform' ./.buildkite/pipeline.yml)" -eq "1" ];
then
  COLLECTED_ERRORS+=("echoboomer/terraform plugin found in Buildkite pipeline, please use a Dockerfile.terraform instead")
fi

# ---
# Print collected errors and exit with non-zero status
if [ ${#COLLECTED_ERRORS[@]} -gt 0 ];
then
  echo "Wiggum found the following errors:"
  for i in "${COLLECTED_ERRORS[@]}"
  do
    echo "   $i"
  done
  echo "Please correct your errors and try again!"
  exit 1
fi

echo "Wiggum completed successfully!"
