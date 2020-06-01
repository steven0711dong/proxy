FROM golang:1.14 AS build

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV GO111MODULE=on
ENV TARGET_OS=linux
ENV TARGET_ARCH=amd64

ENV PROJECT_DIR=/workspace/proxy

WORKDIR ${PROJECT_DIR}

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY /proxy/main.go .
RUN go get -d && CGO_ENABLED=0 go build -ldflags "-w -extldflags -static" -tags netgo -installsuffix netgo -o ./proxy

FROM scratch
COPY --from=build /workspace/proxy/proxy .
ENTRYPOINT [ "./proxy" ]