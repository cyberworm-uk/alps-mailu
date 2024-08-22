FROM --platform=$BUILDPLATFORM docker.io/library/golang:alpine AS build
ARG VERSION=release-branch/1.72 TARGETOS TARGETARCH
ENV GOOS="$TARGETOS" GOARCH="$TARGETARCH" GOFLAGS="-buildvcs=false -trimpath"
WORKDIR /alps.build
RUN apk add --no-cache git
RUN git clone https://git.sr.ht/~migadu/alps .
RUN go mod download
RUN go build -ldflags "-w -s -buildid=" ./cmd/alps

FROM docker.io/library/alpine:latest
COPY --from=build /alps.build/alps /alps/alps
COPY --from=build /alps.build/themes /alps/themes
WORKDIR /alps
USER nobody
ENTRYPOINT [ "/alps/alps" ]