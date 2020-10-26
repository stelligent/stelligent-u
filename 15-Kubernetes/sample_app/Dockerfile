FROM registry.access.redhat.com/ubi8/ubi-minimal
FROM node:12.0-stretch-slim AS builder

ENV APP=/var/www

# Create app directory
RUN mkdir -p $APP
WORKDIR $APP

# Install app dependencies
COPY package*.json $APP/
RUN npm install --production

COPY . $APP
RUN npm run-script build

EXPOSE 8080
CMD ["npm", "run", "start"]


