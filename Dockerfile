FROM docker.yektanet.tech/golang:1.17 as BUILDER

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o kubenurse

FROM docker.yektanet.tech/alpine:latest
MAINTAINER OpenSource PF <opensource@postfinance.ch>

RUN apk --no-cache add ca-certificates curl
COPY --from=BUILDER /app/kubenurse /bin/kubenurse

# Run as nobody:x:65534:65534:nobody:/:/sbin/nologin
USER 65534

CMD ["/bin/kubenurse"]
