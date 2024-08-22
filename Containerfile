FROM docker.io/library/golang:alpine AS build
WORKDIR /alps.build
RUN apk add git && \
        git clone https://git.sr.ht/~migadu/alps .
RUN go mod download
RUN go build -o /alps ./cmd/alps

FROM docker.io/library/alpine:latest
COPY --from=build /alps /alps/alps
COPY --from=build /alps.build/themes /alps/themes
WORKDIR /alps
USER nobody
ENTRYPOINT [ "/alps/alps" ]