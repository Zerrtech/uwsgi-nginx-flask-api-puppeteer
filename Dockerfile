FROM tiangolo/uwsgi-nginx-flask:python3.6

# These couple XML packages are for OneLogin SSO SAML in python
RUN apt-get update && apt-get install -y --no-install-recommends libxml2-dev libxmlsec1-dev \

# packages for nodejs setup
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y \
    curl apt-transport-https apt-utils dialog

ARG NODEREPO="node_8.x"
ARG DISTRO="stretch"
# Only newest package kept in nodesource repo. Cannot pin to version using apt!
# See https://github.com/nodesource/distributions/issues/33
RUN curl -sSO https://deb.nodesource.com/gpgkey/nodesource.gpg.key
RUN apt-key add nodesource.gpg.key
RUN echo "deb https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/${NODEREPO} ${DISTRO} main" >> /etc/apt/sources.list.d/nodesource.list
RUN apt-get update -q && apt-get install -y 'nodejs=8.11.2*'

RUN node --version

# This group of installs is only for setting up reqs for puppeteer
# this list from https://github.com/Googlechrome/puppeteer/issues/290#issuecomment-360542685
RUN apt-get install -yq --no-install-recommends gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget

# we will use yarn to build React and Install puppeteer
RUN curl -o- -L https://yarnpkg.com/install.sh | bash
