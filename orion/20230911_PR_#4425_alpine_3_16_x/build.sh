#!/bin/bash
docker build -t orion.alpine -f Dockerfile.alpine --build-arg GITHUB_ACCOUNT=fisuda --build-arg GIT_NAME=fisuda --build-arg GIT_REV_ORION=hardening/use_old_ssl_version --progress plain . |& tee ~/build.log
