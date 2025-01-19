FROM golang:1.22-alpine as builder

WORKDIR /usr/src/app

COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /usr/src/app/ -ldflags="-w -s" ./...

FROM scratch
WORKDIR /app
COPY --from=builder /usr/src/app/ollama-copilot /usr/local/bin/

CMD ["ollama-copilot"]