FROM node:12-alpine as base

WORKDIR /build
COPY package*.json ./
RUN npm ci --from-lock-file && npm cache clean --force
COPY . .
RUN npm run build && npm prune --production

FROM node:12-alpine
WORKDIR /app

COPY --from=base /build/dist ./dist
COPY --from=base /build/node_modules ./node_modules

USER node
ENV PORT=8080
EXPOSE 8080

CMD ["node", "dist/main.js"]
