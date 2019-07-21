FROM node:9-slim

COPY ./.discounts /discounts
COPY . /server

WORKDIR /server

RUN yarn install

EXPOSE 80

CMD [ "yarn", "start" ]
