#!/bin/bash
docker build -t ace . && docker run --name ace-run --rm --cap-add ALL --security-opt seccomp=unconfined --privileged ace
