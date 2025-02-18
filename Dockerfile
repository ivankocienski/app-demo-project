# based on https://hub.docker.com/_/golang

FROM golang:1.23.5

ENV APP_PGCONFIG=api_demo_role:password@192.168.1.133:5432/api_demo_db

EXPOSE 8002

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]
