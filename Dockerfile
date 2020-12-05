FROM node:12-alpine AS base

LABEL Name="dartwlad-cart-api"
LABEL Version="0.0.1"

# Dependencies
WORKDIR /app
COPY package*.json ./
RUN npm i

# Build
WORKDIR /app
COPY Dockerfile .
RUN npm run build

# Application
FROM node:12-alpine as application

COPY --from=base /app/package*.json ./
RUN npm i --only=production
RUN npm i -g pm2
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8000
EXPOSE 8000

CMD ["pm2-runtime", "dist/main.js"]
