FROM nginx-1.16.1

MAINTAINER issac

ADD nginx.conf /apps/nginx/conf/nginx.conf

COPY index.html /apps/nginx/html/

RUN ln -s /apps/nginx/sbin/nginx /usr/sbin/nginx 

EXPOSE 80 443

CMD ["nginx","-g","daemon off;"]
