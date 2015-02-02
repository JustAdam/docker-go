# GoLang from source.
# For use when developing in Go.
#
# Source code is kept outside of the container (accessed via a volume)
#
# Version 0.1.2

FROM ubuntu:14.04

MAINTAINER JustAdam <adambell7@gmail.com>

RUN apt-get clean && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    apt-get clean

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates make gcc libc6-dev git mercurial && \
    apt-get clean

ENV TIMEZONE Europe/Oslo
RUN echo $TIMEZONE > /etc/timezone &&\
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime &&\
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata


RUN echo "[web]\ncacerts = /etc/ssl/certs/ca-certificates.crt" > /etc/mercurial/hgrc

# Package management tools
RUN git clone https://github.com/pote/gpm.git && \
    cd gpm && \
    DEBIAN_FRONTEND=noninteractive ./configure && \
    DEBIAN_FRONTEND=noninteractive make install
RUN git clone https://github.com/pote/gvp.git && \
    cd gvp && \
    DEBIAN_FRONTEND=noninteractive ./configure && \
    DEBIAN_FRONTEND=noninteractive make install

# Go version information (tag or branch name)
ONBUILD ADD release release
# Clone and build repo
ONBUILD RUN hg clone -u $(cat release)  https://code.google.com/p/go && \
            cd go/src && \
            DEBIAN_FRONTEND=noninteractive ./make.bash

# Other dev tools
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/cover
ONBUILD RUN /go/bin/go get code.google.com/p/go.tools/cmd/vet

# Run as unknown user so hopefully you maintain ownership of any files that are created
RUN groupadd -g 1000 golang && \
    useradd -d /workspace -g 1000 golang
# Permissions thing
ONBUILD USER golang
# http://talks.golang.org/2014/organizeio.slide#14
ONBUILD RUN echo "gocd () { cd `/go/bin/go list -f '{{.Dir}}' $1` }" >> /etc/skel/.profile

ENV PATH $PATH:/go/bin:/workspace/bin
ENV GOPATH /workspace

# Provide port for developing network listener apps
EXPOSE 12345

VOLUME ["/workspace"]
ENTRYPOINT ["/bin/bash"]
