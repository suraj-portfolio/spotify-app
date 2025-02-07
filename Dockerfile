#FROM node:alpine AS BASE

FROM node:alpine AS ui
ARG CLERK_PUBLISHABLE_KEY
ENV VITE_CLERK_PUBLISHABLE_KEY=$CLERK_PUBLISHABLE_KEY
WORKDIR /app
COPY --chown=node:node /frontend/package*.json  ./
RUN  npm ci
COPY --chown=node:node /frontend ./
RUN npm run build

USER node

#FROM node:alpine AS api
#WORKDIR /app
#COPY backend/package*.json ./
#RUN npm install --omit-dev
#COPY /backend .

FROM node:alpine AS api-build
WORKDIR /app
COPY --chown=node:node backend-ts/package*.json ./
RUN npm ci
COPY --chown=node:node /backend-ts .
RUN npm run build
ENV NODE_ENV production

# Running `npm ci` removes the existing node_modules directory and passing in --only=production ensures that only the production dependencies are installed. This ensures that the node_modules directory is as optimized as possible
RUN npm ci --only=production && npm cache clean --force
#COPY /backend-ts/dist .

USER node

FROM node:alpine AS server
WORKDIR /app
COPY package* ./
#RUN npm install --omit-dev
COPY --chown=node:node  --from=ui ./app/dist ./frontend/dist
#COPY --from=api ./app ./backend
COPY --chown=node:node  --from=api-build ./app/dist ./backend-ts/dist
COPY --chown=node:node  --from=api-build ./app/node_modules ./backend-ts/node_modules
COPY --chown=node:node  --from=api-build ./app/package.json ./backend-ts/package.json
EXPOSE 3000
CMD [ "npm", "start" ]