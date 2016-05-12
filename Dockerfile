#
# Simpleflake Service
# https://github.com/traxo/simpleflake-service
#
# Build:
#   docker build -t traxo/simpleflake .
#
# Run:
#   docker run -P -d traxo/simpleflake
#   docker run -P -d --env-file .env traxo/simpleflake
#
# Known Issues:
#   1) TODO: Install s6 process manager
#   2) TODO: Review possible issues with Alpine DNS related
#      to typical service discovery operations:
#      http://gliderlabs.viewdocs.io/docker-alpine/caveats/
#      https://github.com/janeczku/go-dnsmasq
#

FROM alpine:3.3
MAINTAINER Traxo

# The app uses native npm modules, so extra tools are required.
RUN apk --no-cache add make gcc g++ python nodejs

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
  rm -rf /tmp/* /root/.npm /root/.node-gyp

# Environment variables
ENV PORT 3000

# Ports
EXPOSE 3000

# Runtime
CMD ["node", "/opt/traxo/simpleflake/index.js"]
