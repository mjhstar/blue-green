FROM ubuntu:18.04
FROM nginx:1.21.4

RUN rm -rf /etc/nginx/conf.d/default.conf
COPY ./conf.d/nginx.conf  /etc/nginx/nginx.conf
COPY ./conf.d/service-url.inc /etc/nginx/conf.d/service-url.inc
VOLUME ["/data", "/etc/nginx", "/var/log/nginx"]
WORKDIR /etc/nginx
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]