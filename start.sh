#!/bin/bash
docker build -t ace . && docker run --name ace-run --cpus 6 --cap-add=SYS_PTRACE --cap-add=SYS_ADMIN --cap-add=audit_control --security-opt seccomp=unconfined ace 
