#
# Simpleflake Service
#
# Build:
#   docker build -t traxo/simpleflake .
#
# Run:
#   docker run -P -d traxo/simpleflake
#   docker run -P -d --env-file .env traxo/simpleflake
#
# Known Issues:
#   1) gliderlabs/alpine:3.2 and nodejs latest:
#      https://bugs.alpinelinux.org/issues/4999
#   2) smebberson/alpine-nodejs:
#      runtime error: process.dlopen
#

# FROM smebberson/alpine-nodejs
FROM gliderlabs/alpine:3.2

# The app uses native npm modules, so extra tools are required.
RUN apk add --update make gcc g++ python nodejs

# Cache package.json and node_modules to speed up builds
ADD package.json package.json

# Install S6 process configuration
# ADD provision/docker/etc/ /etc/

RUN mkdir -p /opt/traxo/simpleflake
WORKDIR /opt/traxo/simpleflake

# Copy the application source
COPY . /opt/traxo/simpleflake

# Build steps
RUN cd /opt/traxo/simpleflake; \
npm install

# Remove build tools for the native modules
RUN apk del make gcc g++ python && \
  rm -rf /tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp

# Environment variables
ENV PORT 3000

# Ports
EXPOSE 3000

# Runtime
CMD ["node", "/opt/traxo/simpleflake/index.js"]
