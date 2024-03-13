FROM golang:alpine AS builder

WORKDIR /usr/src/app

COPY go.mod ./

RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/app -tags netgo -installsuffix netgo -ldflags '-extldflags "-static"' index.go

FROM scratch

WORKDIR /usr/src/app

COPY --from=builder /usr/local/bin/app /app

CMD ["/app"]
