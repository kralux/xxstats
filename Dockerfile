FROM node:16-bullseye
RUN apt update && apt upgrade -y && apt autoremove -y
RUN apt install -y git build-essential apt-transport-https ca-certificates gpg-agent curl software-properties-common libpq-dev

WORKDIR /usr/app/

COPY . /usr/app/

EXPOSE 7443
EXPOSE 3000

RUN yarn workspace frontend dev

CMD ["yarn", "start"]
