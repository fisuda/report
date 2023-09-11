#!/bin/bash
docker build -t orion.alpine -f Dockerfile.alpine --progress plain . |& tee /tmp/orion-alpine-build.log
