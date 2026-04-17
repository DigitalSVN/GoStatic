FROM alpine:3.23

# Install the curl and jq packages
RUN apk --no-cache add curl jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]