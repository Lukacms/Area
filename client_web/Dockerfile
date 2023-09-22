FROM node:14.9

WORKDIR /usr/src/app/client_web

COPY package*.json ./

RUN npm install

#COPY . .

EXPOSE 8081

CMD [ "npm", "start" ]
