FROM node:16-bullseye
RUN apt update && apt upgrade -y && apt autoremove -y
RUN apt install -y git build-essential apt-transport-https ca-certificates gpg-agent curl software-properties-common libpq-dev
RUN curl -fsSL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN npm install --global --force yarn


WORKDIR /usr/app/frontend

COPY . /usr/app/frontend

EXPOSE 7443

RUN yarn install
# RUN npm install --save bignumber.js
RUN yarn dev
# RUN yarn build
# RUN yarn start
# RUN yarn generate


# RUN yarn workspace frontend dev

CMD ["yarn", "start"]
