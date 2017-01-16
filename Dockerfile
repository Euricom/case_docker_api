FROM node:alpine

# Create app directory in container & output folder (for docker image / artifacts in CircleCI)
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy node app source code to dir in container
COPY . /usr/src/app
RUN npm install --production

# Expose port in container
EXPOSE 80

# Start NPM (executes node ./server/server through package.json)
CMD [ "npm", "start" ]