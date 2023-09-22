FROM node:alpine as build

WORKDIR /app

COPY package*.json /app

RUN npm install

COPY . /app

EXPOSE 8081

RUN npm start
