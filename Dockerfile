# Golang from source
# For use when developing in Go.
#
# Source code is kept outside of the container and accessed via a volume.
#
# Version 0.1.3
#

FROM ubuntu:15.04

MAINTAINER JustAdam <adambell7@gmail.com>

ENV TIMEZONE Europe/Oslo
RUN echo $TIMEZONE > /etc/timezone &&\
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime &&\
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata

ONBUILD ADD release /release
ONBUILD ENV GOROOT_BOOTSTRAP /go1.4/go/
ONBUILD RUN apt-get clean && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git wget gcc && \
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
    rm -rf /go1.4

#RUN 

# Some dev tools
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/...
ONBUILD RUN /go/bin/go get github.com/golang/lint/golint
ONBUILD RUN /go/bin/go get github.com/kisielk/errcheck

# Package management from gb
ONBUILD RUN /go/bin/go get github.com/constabulary/gb/...

# Hopefully you are uid/gid 1000, so we maintain ownership of any files that are created
RUN groupadd -g 1000 golang && \
    useradd -d /workspace -g 1000 golang

ENV PATH $PATH:/go/bin:/workspace/bin:/gopath/bin
# Go tools
RUN mkdir /gopath
ENV GOPATH /gopath

# File permissions thing
ONBUILD USER golang

VOLUME ["/workspace"]
ENTRYPOINT ["/bin/bash"]

