FROM orskycloud_base

RUN apk add --no-cache \
    redis 

RUN cd /etc && mkdir redis
COPY redis/  /etc/redis
VOLUME ["/etc/redis/database"]

EXPOSE  6379

CMD ["/usr/bin/redis-server", "/etc/redis/redis.conf"]
