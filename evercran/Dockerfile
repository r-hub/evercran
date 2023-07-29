FROM node:18-alpine

WORKDIR /src
COPY package*.json /
EXPOSE 3000

RUN npm install -g nodemon && npm install
COPY . .
RUN npm ci

CMD ["npm", "start"]
