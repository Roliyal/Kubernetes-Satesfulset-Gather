FROM nginx

MAINTAINER issac 

EXPOSE 80 443

CMD ["nginx","-g","daemon off;"]
