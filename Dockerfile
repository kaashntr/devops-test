#Build stage
FROM node:alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build
#Prod stage
FROM node:alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=build /app/dist ./dist
RUN adduser -D nestapp
USER nestapp
CMD ["node", "dist/main.js"]