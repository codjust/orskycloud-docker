FROM orskycloud_base

RUN apk add --no-cache \
    redis 
RUN apk --update add supervisor go build-base 
RUN mkdir /etc/redis && mkdir /home/go /home/go/src /home/go/pkg /home/go/bin  /home/go/src/orskycloud-go \
    && mkdir /opt/data
COPY redis/  /etc/redis
VOLUME ["/etc/redis/database"]
COPY orskycloud-go /home/go/src/orskycloud-go
RUN echo "export GOPATH=/home/go:/home/go/src/orskycloud-go export PATH=$PATH:$GOPATH" > /etc/profile \
    && source /etc/profile \
    && cd /home/go/src/orskycloud-go \
    && go build -a
COPY supervisord.conf /etc/
COPY apidoc /opt/data
EXPOSE 6379 9001 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
