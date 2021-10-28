# pull the base image
FROM node:16-alpine

RUN apk add --no-cache python3 py3-pip bash net-tools iproute2 build-base gcc pkgconfig python3-dev tzdata

# set the working direction
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY package.json ./

RUN npm install

# add app
COPY . ./

RUN pip3 install -r cpu_killer/requirements.txt

ENV CHOKIDAR_USEPOLLING=true
# Fix for timezone
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime

CMD ["npm", "start"]
