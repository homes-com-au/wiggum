#!/bin/bash

# Wiggum
# ======
# A lightweight DevOps linter
# Checking for consistent DevOps patterns across codebases

set -e

echo "Wiggum is running..."
COLLECTED_ERRORS=()

source .wiggum

# root directory of the repository
REPO_DIR="."
# diretory for infrastructure releated files. 
# default is the $REPO_DIR
INFRA_DIR=$REPO_DIR

# use the .infra directory layout for all infrastructure files/config
if [[ -n "${USE_DOT_INFRA}" ]] && [[ "${USE_DOT_INFRA}" == "true" ]];
then
  INFRA_DIR="${REPO_DIR}/.infra"
  if [ ! -d "${INFRA_DIR}" ];
  then 
        COLLECTED_ERRORS+=("USE_DOT_INFRA set but ${INFRA_DIR} does not exist")
  fi
fi

# Check that a README file exists
if [[ -z "${CHECK_README}" ]] || [[ "${CHECK_README}" == "true" ]];
then
  if [[ ! -f "${REPO_DIR}/README.md" ]] && [[ ! -f "${REPO_DIR}/README.txt" ]] && [[ ! -f "${REPO_DIR}/README" ]];
  then
    COLLECTED_ERRORS+=("README does not exist")
  fi
else
  echo "Skipping README check"
fi

# Check that Docker files are present with preferred naming convention
if [[ -z "${CHECK_DOCKER}" ]] || [[ "${CHECK_DOCKER}" == "true" ]];
then
  DOCKER_SHOULD_EXIST=( ${INFRA_DIR}/Dockerfile ${INFRA_DIR}/docker-compose.yml ${INFRA_DIR}/.dockerignore  )
  for i in "${DOCKER_SHOULD_EXIST[@]}"
  do
    if [ ! -f "$i" ];
    then
      COLLECTED_ERRORS+=("Docker file $i does not exist")
    fi
  done

  # Check that Dockerfiles are alpha sorted
  if [ "$(ls ${INFRA_DIR}/*-Dockerfile 2> /dev/null | wc -l)" -ge "1" ];
  then
    COLLECTED_ERRORS+=("Dockerfile naming convention should be 'Dockerfile', 'Dockerfile.<env>' or 'Dockerfile-<env>'")
  fi

  # Check that there's a 'test' service in Docker Compose
  if [ "$(grep -c '^  test:' ${INFRA_DIR}/docker-compose.yml)" -eq "0" ];
  then
    COLLECTED_ERRORS+=("'test:' service not found in docker-compose.yml")
  fi

  # Check that there's a .git entry in .dockerignore
  if [ "$(grep -c '.git' ${INFRA_DIR}/.dockerignore)" -eq "0" ];
  then
    COLLECTED_ERRORS+=("'.git' not found in ./.dockerignore")
  fi
else
  echo "Skipping Dockerfile check"
fi

# set buildkite config path
BUILDKITE_DIR="./.buildkite"
BUILDKITE_FILE="pipeline.yml"
if [[ -n "${USE_DOT_INFRA}" ]] && [[ "${USE_DOT_INFRA}" == "true" ]];
then
  BUILDKITE_DIR=$INFRA_DIR
  BUILDKITE_FILE=buildkite.yml
fi

# Check that Buildkite is present
if [[ -z "${CHECK_BUILDKITE}" ]] || [[ "${CHECK_BUILDKITE}" == "true" ]];
then
  BUILDKITE_DIR_SHOULD_EXIST=( ${BUILDKITE_DIR} )
  for i in "${BUILDKITE_DIR_SHOULD_EXIST[@]}"
  do
    if [ ! -d "$i" ];
    then
      COLLECTED_ERRORS+=("Buildkite directory $i does not exist")
    fi
  done
  BUILDKITE_SHOULD_EXIST=( ${BUILDKITE_DIR}/${BUILDKITE_FILE} )
  for i in "${BUILDKITE_SHOULD_EXIST[@]}"
  do
    if [ ! -f "$i" ];
    then
      COLLECTED_ERRORS+=("Buildkite file $i does not exist")
    fi
  done

  # Check that there's a 'test' step in BuildKite
  if [ "$(grep -c "^    key: 'test'" ${BUILDKITE_DIR}/${BUILDKITE_FILE})" -eq "0" ];
  then
    COLLECTED_ERRORS+=("Key marked 'test' not found in ${BUILDKITE_DIR}/${BUILDKITE_FILE}")
  fi

  # Check that Wiggum runs in Buildkite pipeline
  if [ "$(grep -c "wiggum.sh" ${BUILDKITE_DIR}/${BUILDKITE_FILE})" -eq "0" ];
  then
    COLLECTED_ERRORS+=("Wiggum not found in ${BUILDKITE_DIR}/${BUILDKITE_FILE}")
  fi
else
  echo "Skipping Buildkite check"
fi

# Check that Terraform is present
if [[ -z "${CHECK_TERRAFORM}" ]] || [[ "${CHECK_TERRAFORM}" == "true" ]];
then
  TERRAFORM_SHOULD_EXIST=( ${INFRA_DIR}/terraform )
  for i in "${TERRAFORM_SHOULD_EXIST[@]}"
  do
    if [ ! -d "$i" ];
    then
      COLLECTED_ERRORS+=("Terraform directory $i does not exist")
    fi
  done

  # Check that the terraform plugin is not being used in Buildkite pipeline
  if [[ -z "${CHECK_BUILDKITE}" ]] || [[ "${CHECK_BUILDKITE}" == "true" ]];
  then
    if [ "$(grep -c 'echoboomer/terraform' ${BUILDKITE_DIR}/${BUILDKITE_FILE})" -eq "1" ];
    then
      COLLECTED_ERRORS+=("echoboomer/terraform plugin found in Buildkite pipeline which is known to be out of date, please use a Dockerfile.terraform instead")
    fi
  fi
else
  echo "Skipping Terraform check"
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