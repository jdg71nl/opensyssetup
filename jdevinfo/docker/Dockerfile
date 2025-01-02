#= Dockerfile

## Use this file:
# > docker build -t react-app .
## About error: Get "https://registry-1.docker.io/v2/": dial tcp [2600:1f18:2148:bc02:445d:9ace:d20b:c303]:443: connect: network is unreachable
## https://forums.docker.com/t/force-docker-to-only-use-ipv4/140486
## can do
# > cat /etc/sysctl.conf | grep ^net.ipv6
# net.ipv6.conf.all.disable_ipv6 = 1
# net.ipv6.conf.default.disable_ipv6 = 1

## can define .dockerignore file to skip items during COPY:
# > cat .dockerignore 
# node_modules/

## Note: you can start a remote-image directly:
# > docker run -it alpine       # <== if without command, then the in-file CMD is used
# > docker run -it alpine sh    # <== if command is provided, the in-file CMD is aignored

## -- FROM
## Note: FROM adds a base-layer (with this file image becoming a new layer) (an IMAGE is a collection of LAYERS) 
## https://hub.docker.com/_/node
## 22-alpine
## https://github.com/nodejs/docker-node/blob/12a54cd19fc05ecaf5a9aecc9e5280a37057835f/22/alpine3.21/Dockerfile
## https://raw.githubusercontent.com/nodejs/docker-node/12a54cd19fc05ecaf5a9aecc9e5280a37057835f/22/alpine3.21/Dockerfile
## see copy in: ~/dev/playground/TUDC-The-Ultimate-Docker-Course/node:22-alpine/Dockerfile 
# FROM node:22-alpine
FROM node:14.16.0-alpine3.13

## -- RUN
## RUN is a build-time instruction
## Note: these 'addgroup' and 'adduser' commands may be alpine specific
RUN addgroup app && adduser -S -G app app

## Tip from: https://stackoverflow.com/questions/45553074/cannot-create-directory-permission-denied-inside-docker-container
## do this manual before USER & WORKDIR:
RUN mkdir -p /app
RUN chown app.app /app

## -- USER
USER app
##
## info: https://www.docker.com/blog/understanding-the-docker-user-instruction/
## you can switch between users:
# RUN useradd -ms /bin/bash myuser
# USER myuser
# RUN some
# USER root
# RUN apt-get update && apt-get install -y some-package
# USER myuser

## -- WORKDIR
## Note: WORKDIR defines dir in container:
WORKDIR /app

## Tip from: https://www.docker.com/blog/understanding-the-docker-user-instruction/
# RUN sh -c "echo 'Inside Container:' && echo 'User: $(whoami) UID: $(id -u) GID: $(id -g)'"

## -- COPY
## Copy files from 'build-context' into 'container'
## Mosh says:
## COPY  <== is cleaner no magic
## ADD   <== can auto unzip, can use URL as source
## Note: target-dir is auto-created
## Note: if multiple files then target is dir with trailing-slash/
# COPY package.json /app
# COPY package.json README.md /app/
# COPY . /app/
## if WORKDIR is defined you can just write "."
# COPY . .
## in this form we cannot use spaces:
# COPY hello world.txt .
## for space we need to write this form:
# COPY ["hello world.txt", "."]
##
# COPY . .
## [a] little trick to speed-up build-ing: first only copy package*.json, then 'npm install', which only installs modified npm pkgs:
COPY package*.json ./
  
## -- RUN
RUN npm install

## [b] then copy the rest:
COPY . .

## Optional: manually set permissions: (but no need because only /app/ needs to be writable)
# USER root
# RUN chown app.app -R /app
# USER app

## -- ENV
ENV API_URL=http://api.myapp.com/

## -- EXPOSE
## Note: this does not yet open a port in host, that is done later in run-cmd:
EXPOSE 3000

## -- ENTRYPOINT
# ENTRYPOINT does the same as CMD but it is not (easily) overridden in cmdline
# ENTRYPOINT ["npm", "start"]

## -- CMD
## CMD is a run-time instruction
## shell form:
# CMD npm start
## Exec form:
## Mosh says:
## always use the Execute-form
CMD ["npm", "start"]

## Summary from: node:22-alpine/Dockerfile:
# FROM alpine:3.21
# ENV NODE_VERSION 22.12.0
# RUN addgroup -g 1000 node \ ...
# ENV YARN_VERSION 1.22.22
# RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \ ...
# COPY docker-entrypoint.sh /usr/local/bin/
# ENTRYPOINT ["docker-entrypoint.sh"]
# CMD [ "node" ]

## Example from ~/dev/playground/TUDC-The-Ultimate-Docker-Course/section6-vidly/vidly/backend/Dockerfile:
# FROM node:14.16.0-alpine3.13
# RUN addgroup app && adduser -S -G app app
# USER app
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . . 
# EXPOSE 3001 
# CMD ["npm", "start"]

#-eof
