#!/bin/bash

. registry.conf

docker tag "${REPO}:${TAG}" "${REGISTRY}/${REPO}:${TAG}"
docker push "${REGISTRY}/${REPO}:${TAG}"

