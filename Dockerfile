FROM centos:centos7.7.1908 

MAINTAINER wangxiaochun <root@wangxiaochun.com>

RUN yum install -y  gcc gcc-c++  pcre pcre-devel zlib zlib-devel openssl openssl-devel \
    && useradd -r -s /sbin/nologin nginx \
    && yum clean all 

ADD nginx-1.16.1.tar.gz /usr/local/src/ 

RUN cd /usr/local/src/nginx-1.16.1 \
    && ./configure --prefix=/apps/nginx \
    && make \
    && make install \
    && rm -rf /usr/local/src/nginx*

ADD nginx.conf /apps/nginx/conf/nginx.conf

COPY index.html /apps/nginx/html/

RUN ln -s /apps/nginx/sbin/nginx /usr/sbin/nginx 

EXPOSE 80 443

CMD ["nginx","-g","daemon off;"]
