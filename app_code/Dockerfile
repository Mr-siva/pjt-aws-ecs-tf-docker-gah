FROM nginx:alpine

# directory for httpd /usr/share/nginx/html
WORKDIR /usr/share/nginx/html

# local to containter
COPY . /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]