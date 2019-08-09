FROM node:9-alpine

COPY ./discounts /discounts
COPY ./products /server

WORKDIR /server

RUN yarn install

EXPOSE 80

CMD [ "yarn", "start" ]
