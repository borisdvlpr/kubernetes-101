FROM golang:1.23-bookworm AS base

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o k8s-web

EXPOSE 8080

CMD ["/app/k8s-web"]
