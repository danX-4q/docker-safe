#!/bin/bash

. registry.conf

docker pull "${REGISTRY}/${REPO}:${TAG}"
docker tag "${REGISTRY}/${REPO}:${TAG}" "${REPO}:${TAG}"

