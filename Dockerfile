FROM golang:alpine
LABEL maintainer="Marcel Juhnke <marcel.juhnke@karrieretutor.de>"

ENV GOPATH /go

RUN apk add --update git

WORKDIR /go

RUN git clone https://github.com/karrieretutor/go-oidc src/github.com/coreos/go-oidc
RUN git clone https://github.com/karrieretutor/oauth2_proxy src/github.com/bitly/oauth2_proxy

RUN go get -v github.com/bitly/oauth2_proxy

FROM alpine:latest
RUN apk --no-cache add ca-certificates

COPY --from=0 /go/bin/oauth2_proxy /usr/local/bin

# Expose the ports we need and setup the ENTRYPOINT w/ the default argument
# to be pass in.
EXPOSE 8080 4180
ENTRYPOINT [ "oauth2_proxy" ]
CMD [ "--upstream=http://0.0.0.0:8080/", "--http-address=0.0.0.0:4180" ]
