# based on https://hub.docker.com/_/golang

FROM golang:1.23.5

# this is pulled from the environment
ARG APP_PGCONFIG

EXPOSE 8002

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

# CMD ["app"]
ENTRYPOINT ["app"]
