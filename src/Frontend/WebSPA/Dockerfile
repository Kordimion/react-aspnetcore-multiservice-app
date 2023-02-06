# build environment
FROM node:alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY Frontend/WebSPA/page/package.json ./
COPY Frontend/WebSPA/page/package-lock.json ./
ARG BASE_URL
ARG TOKEN_SERVICE_URL
ARG OIDC_CLIENT_SECRET
ARG CERTS_PATH=srv/buildcertificate/rootca

RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent
COPY ./Frontend/WebSPA/page ./
RUN REACT_APP_API_URL=$BASE_URL REACT_APP_TOKEN_SERVICE_URL=$TOKEN_SERVICE_URL REACT_APP_OIDC_CLIENT_SECRET=$OIDC_CLIENT_SECRET npm run build

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

COPY srv/nginx/backend.conf.template /etc/nginx/templates/default.conf.template

RUN mkdir -p /usr/share/nginx/html/ref/
COPY Frontend/WebSPA/nginx/links.html /usr/share/nginx/html/ref/index.html

RUN mkdir -p /https 
COPY $CERTS_PATH /https
RUN cp -R /https/* /usr/local/share/ca-certificates
RUN update-ca-certificates -f
