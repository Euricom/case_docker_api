FROM node:alpine

# Create app directory in container
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy node app source code to dir in container
COPY . /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install

# Expose port in container
EXPOSE 3000

# Start NPM (executes node ./server/server through package.json)
CMD [ "npm", "start" ]

