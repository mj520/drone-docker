FROM mj520/golang AS build
MAINTAINER build
ENV AppName=main PackagePath=drone-docker
# PackagePath is a directory relative to main.go to ${GOPATH}/src
ADD . ${GOPATH}/src/${PackagePath}
WORKDIR ${GOPATH}/src/${PackagePath}
RUN go build -mod=vendor -ldflags "-s -w" -o /build/${AppName} cmd/drone-docker/main.go && \
    upx -1 /build/${AppName} && chmod +x /build/${AppName}
#&& mv your need file and directory to /build/
#second
FROM docker:dind

ENV AppName=main

ENV DOCKER_HOST=unix:///var/run/docker.sock

COPY --from=build /build/${AppName} /bin/drone-docker

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "/bin/drone-docker"]