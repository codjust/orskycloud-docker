FROM alpine:edge
COPY repositories /etc/apk/repositories
RUN apk add --no-cache \
            tzdata \
            curl \
            bash \
            sed \
            procps \
            && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
            && echo "Asia/Shanghai" > /etc/timezone \
            && apk del tzdata

