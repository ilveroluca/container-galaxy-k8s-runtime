#!/bin/bash

set -x
set -o errexit
set -o nounset

DockerRepo=${DockerRepo:-pcm32}
DoPush=${DoPush:-false}

ANSIBLE_REPO=galaxyproject/ansible-galaxy-extras
ANSIBLE_RELEASE=86a127ae3aaaea125c8faa0271471106f2a4f889

GALAXY_RELEASE=b7dc87e872c14878a929237b3cb6d8fe2c579e5d
GALAXY_REPO=phnmnl/galaxy

docker build --build-arg ANSIBLE_REPO=$ANSIBLE_REPO --build-arg ANSIBLE_RELEASE=$ANSIBLE_RELEASE -t ${DockerRepo}/galaxy-base-pheno ../docker-galaxy-stable/compose/galaxy-base/

docker build --build-arg GALAXY_REPO=$GALAXY_REPO --build-arg GALAXY_RELEASE=$GALAXY_RELEASE -t ${DockerRepo}/galaxy-init-pheno ../docker-galaxy-stable/compose/galaxy-init/

docker build -t ${DockerRepo}/galaxy-init-pheno-flavoured -f Dockerfile_init .

docker build -t ${DockerRepo}/galaxy-stable-k8s ../docker-galaxy-stable/compose/galaxy-k8s/

if [[ ${DoPush} = true ]]; then
  docker push ${DockerRepo}/galaxy-base-pheno
  docker push ${DockerRepo}/galaxy-init-pheno
  docker push ${DockerRepo}/galaxy-init-pheno-flavoured
  docker push ${DockerRepo}/galaxy-stable-k8s
fi
