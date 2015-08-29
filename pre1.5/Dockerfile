# GoLang from source.
# For use when developing in Go.
#
# Source code is kept outside of the container (accessed via a volume)
#
# Version 0.1.2

FROM ubuntu:14.10

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

# Go version information (tag or branch name)
ONBUILD ADD release /release
# Clone and build repo
ONBUILD RUN git clone https://go.googlesource.com/go && \
            cd go && \
            git checkout $(cat /release) && \
            cd src && \
            DEBIAN_FRONTEND=noninteractive ./make.bash

# Other dev tools
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/cover
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/vet 
ONBUILD RUN /go/bin/go get github.com/golang/lint/golint
ONBUILD RUN /go/bin/go get github.com/kisielk/errcheck
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/benchcmp
ONBUILD RUN /go/bin/go get golang.org/x/tools/cmd/stringer

# Package management
ONBUILD RUN /go/bin/go get github.com/constabulary/gb/...

# Hopefully you are uid 1000 so we maintain ownership of any files that are created
RUN groupadd -g 1000 golang && \
    useradd -d /workspace -g 1000 golang

# http://talks.golang.org/2014/organizeio.slide#14
ONBUILD RUN echo "gocd () { cd `/go/bin/go list -f '{{.Dir}}' $1` }" >> /etc/skel/.profile

# Permissions thing
ONBUILD USER golang

ENV PATH $PATH:/go/bin:/workspace/bin:/gopath/bin
RUN mkdir /gopath
ENV GOPATH /gopath

# Provide port for developing network listener apps
EXPOSE 12345

VOLUME ["/workspace"]
ENTRYPOINT ["/bin/bash"]
