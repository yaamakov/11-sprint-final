FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git ca-certificates tzdata

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN go build -o main .

FROM alpine:3

RUN adduser -D -s /bin/sh practicum

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/tracker.db .

RUN chown -R practicum:practicum /app

USER practicum

CMD ["./main"]
