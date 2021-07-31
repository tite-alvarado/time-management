FROM node:latest
COPY timeoff-management-application /app
WORKDIR /app
RUN npm install
EXPOSE 3000
ENTRYPOINT ["npm","start"]
