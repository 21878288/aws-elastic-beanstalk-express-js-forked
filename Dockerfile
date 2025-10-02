#use official Node.js image as base
FROM node:16  
#set working directory inside container 
WORKDIR /usr/src/app
#copy package.json and package-lock.json first
COPY package*.json ./
#install dependencies
RUN npm install
#copy rest of application to container
COPY . .
#expose app port
EXPOSE 8081
#start app
CMD ["npm", "start"]
