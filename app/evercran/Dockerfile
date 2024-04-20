FROM node:20-alpine

WORKDIR /src
COPY app/evercran/package*.json /
EXPOSE 80
ENV PORT=80

RUN npm install -g nodemon && npm install
COPY app/evercran .
RUN npm ci

CMD ["npm", "start"]
