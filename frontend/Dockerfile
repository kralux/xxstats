FROM node:fermium

WORKDIR /usr/app/frontend

COPY . /usr/app/frontend

EXPOSE 7443

RUN yarn workspace frontend dev

CMD ["yarn", "start"]
