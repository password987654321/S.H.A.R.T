#!/bin/pwsh
docker build -t ace . ; if($?) {docker run --name ace-run --rm --cap-add ALL --security-opt seccomp=unconfined --privileged ace}
