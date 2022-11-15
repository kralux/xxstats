FROM node:fermium
RUN apt update && apt upgrade -y && apt autoremove -y
RUN apt install -y git build-essential apt-transport-https ca-certificates gpg-agent curl software-properties-common libpq-dev
RUN curl -fsSL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt install -y nodejs
RUN npm install --global --force yarn

WORKDIR /usr/app/frontend

COPY . /usr/app/frontend

EXPOSE 7443

RUN yarn workspace frontend dev

CMD ["yarn", "start"]


failed to deploy a stack: 
frontend Pulling frontend Error failed to solve:
 executor failed running [/bin/sh -c npm install --global yarn]: exit code: 239