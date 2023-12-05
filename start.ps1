docker build -t ace . -and docker run --name ace-run --rm --cap-add ALL --security-opt seccomp=unconfined --privileged ace
