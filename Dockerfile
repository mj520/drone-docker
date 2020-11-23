FROM mj520/golang AS build
MAINTAINER build
ENV AppName=main PackagePath=drone-docker
ENV AppName=main PackagePath=path/relative
# PackagePath is a directory relative to main.go to ${GOPATH}/src
ADD . ${GOPATH}/src/${PackagePath}
WORKDIR ${GOPATH}/src/${PackagePath}
RUN go build -ldflags "-s -w" -o /build/${AppName} main.go && \
    upx -1 /build/${AppName} && chmod +x /build/${AppName}
#&& mv your need file and directory to /build/
#second
FROM docker:dind

ENV AppName=main

ENV DOCKER_HOST=unix:///var/run/docker.sock

ADD --from=build /build/${AppName} /bin/drone-docker

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "/bin/drone-docker"]