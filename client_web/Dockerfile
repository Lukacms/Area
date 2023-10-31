FROM node:alpine as build

WORKDIR /app

COPY package*.json /app

RUN npm install

COPY . /app

EXPOSE 8091

CMD ["npm", "start"]
