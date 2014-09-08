# GoLang from source.
# For use when developing in Go.
#
# Source code is kept outside of the container (accessed via a volume)
#
# Version 0.1.1

FROM ubuntu:14.04

MAINTAINER JustAdam <adambell7@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y make gcc libc6-dev git mercurial

RUN echo "[web]\ncacerts = /etc/ssl/certs/ca-certificates.crt" > /etc/mercurial/hgrc

# Go version information (tag or branch name)
ONBUILD ADD release release
ONBUILD RUN hg clone -u $(cat release)  https://code.google.com/p/go && \
            cd go/src && \
            ./make.bash

# Add your username/group here, so when writing to /workspace from the container you still own the files.
RUN groupadd -g <GROUP_ID> <USERNAME> && \
    useradd -d /workspace -g <GROUP_ID> <USERNAME>
# Permissions thing
ONBUILD USER <USERNAME>

ENV GOPATH /workspace
ENV PATH $PATH:/go/bin:/workspace/bin

ONBUILD RUN /go/bin/go get code.google.com/p/go.tools/cmd/cover
ONBUILD RUN /go/bin/go get code.google.com/p/go.tools/cmd/vet

VOLUME ["/workspace"]
ENTRYPOINT ["/bin/bash"]
