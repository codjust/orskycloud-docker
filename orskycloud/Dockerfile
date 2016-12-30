FROM alpine_base

RUN apk add --no-cache \
    zlib-dev libpcrecpp libpcre16 libpcre32 libgcc libstdc++ libssl1.0 \
     openssl pcre sed python2 git  netcat-openbsd wget

ENV OPENRESTY_VERSION 1.11.2.1
ENV OPENRESTY_PREFIX /opt/openresty  
ENV NGINX_PREFIX /opt/openresty/nginx 
ENV VAR_PREFIX /var/nginx 

RUN echo "==> Install dependencies..." \
    && apk add --no-cache --virtual build-deps \
        make gcc musl-dev \
        pcre-dev openssl-dev ncurses-dev readline-dev \
        perl \
    && mkdir -p /root/ngx_openresty \
    && cd /root/ngx_openresty \
    && echo "==> Download OpenResty..." \
    && curl -sSL http://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz | tar -xvz \
    && cd openresty-* \
    && echo "==> Configuring OpenResty..." \
    && ./configure \
            --prefix=$OPENRESTY_PREFIX \
            --http-client-body-temp-path=$VAR_PREFIX/client_body_temp \
            --http-proxy-temp-path=$VAR_PREFIX/proxy_temp \
            --http-log-path=$VAR_PREFIX/access.log \
            --error-log-path=$VAR_PREFIX/error.log \
            --pid-path=$VAR_PREFIX/nginx.pid \
            --lock-path=$VAR_PREFIX/nginx.lock \
            --with-luajit \
            --with-pcre-jit \
            --with-ipv6 \
            --with-http_ssl_module \
            --without-http_ssi_module \
            --without-http_userid_module \
            --without-http_uwsgi_module \
            --without-http_scgi_module \
    && echo "==> Building OpenResty..." \
    && make \
    && make install \
    && echo "==>Finishing..." \
    && ln -sf $NGINX_PREFIX/sbin/nginx /usr/local/bin/nginx \
    && ln -sf $NGINX_PREFIX/sbin/nginx /usr/local/bin/openresty \
    && ln -sf $OPENRESTY_PREFIX/bin/resty /usr/local/bin/resty \
    && ln -sf $OPENRESTY_PREFIX/luajit/bin/luajit-* $OPENRESTY_PREFIX/luajit/bin/lua \
    && ln -sf $OPENRESTY_PREFIX/luajit/bin/luajit-* /usr/local/bin/lua \
    && apk del build-deps \
    && rm -rf /root/ngx_openresty

EXPOSE 80 
CMD ["nginx", "-p", "/opt/openresty/nginx"]


