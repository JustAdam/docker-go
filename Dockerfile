# Golang from source
# For use when developing in Go.
#
# Source code is kept outside of the container and accessed via a volume.
#
# Version 0.1.4
#

FROM ubuntu:18.04

MAINTAINER JustAdam <adambell7@gmail.com>

ENV PROTOCOL_BUFFERS_VERSION 3.5.1

ONBUILD ADD release /release
ONBUILD ENV GOROOT_BOOTSTRAP /go1.4/go/
ONBUILD RUN apt-get clean && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git mercurial make wget gcc unzip && \
    apt-get clean && \
    wget https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz && \
    mkdir go1.4 && \
    tar -C go1.4 -xvf go1.4.2.linux-amd64.tar.gz && \ 
    rm go1.4.2.linux-amd64.tar.gz && \
    git clone https://go.googlesource.com/go && \
    cd go && \
    git checkout $(cat /release) && \
    cd src && \
    DEBIAN_FRONTEND=noninteractive ./make.bash && \
    rm -rf /go1.4 && \
    mkdir protoc && \
    cd protoc && \
    wget https://github.com/google/protobuf/releases/download/v${PROTOCOL_BUFFERS_VERSION}/protoc-${PROTOCOL_BUFFERS_VERSION}-linux-x86_64.zip && \
    unzip protoc-${PROTOCOL_BUFFERS_VERSION}-linux-x86_64.zip && \
    mv bin/protoc /usr/local/bin/protoc && \
    chmod +x  /usr/local/bin/protoc && \
    cd .. && \
    rm -rf protoc

ONBUILD RUN echo "[web]\ncacerts = /etc/ssl/certs/ca-certificates.crt" > /etc/mercurial/hgrc

# Some dev tools
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/...
ONBUILD RUN /go/bin/go get github.com/golang/lint/golint
ONBUILD RUN /go/bin/go get github.com/kisielk/errcheck
ONBUILD RUN /go/bin/go get -u github.com/derekparker/delve/cmd/dlv

# Package management stuff
ONBUILD RUN /go/bin/go get -u github.com/govend/govend
ONBUILD RUN /go/bin/go get -u github.com/golang/dep/cmd/dep
ONBUILD RUN /go/bin/go get github.com/constabulary/gb/...

# Go protocol buffer support
ONBUILD RUN /go/bin/go get -u github.com/golang/protobuf/protoc-gen-go

# Hopefully you are uid/gid 1000, so we maintain ownership of any files that are created
RUN groupadd -g 1000 golang && \
    useradd -d /workspace -g 1000 golang

ENV PATH $PATH:/go/bin:/workspace/bin:/gopath/bin
# Go tools
RUN mkdir /gopath
ENV GOPATH /gopath

# File permissions thing
ONBUILD USER golang

# Default vendoring support
ONBUILD ENV GOPATH /gopath:/workspace

VOLUME ["/workspace"]
ENTRYPOINT ["/bin/bash"]
