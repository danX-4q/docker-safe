#!/bin/bash

. registry.conf

docker rmi "${REGISTRY}/${REPO}:${TAG}"
docker rmi "${REPO}:${TAG}"

