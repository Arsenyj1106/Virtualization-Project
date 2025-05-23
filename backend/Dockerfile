FROM node:18-alpine

WORKDIR /backend

RUN apk add --no-cache ca-certificates wget postgresql-client

RUN mkdir -p /root/.postgresql && \
    wget -O /root/.postgresql/root.crt https://storage.yandexcloud.net/cloud-certs/CA.pem

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 8000
CMD ["node", "server.js"]