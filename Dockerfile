ARG NODE_ENV=production
ARG VITE_CLERK_PUBLISHABLE_KEY

FROM node:20-alpine AS ui
ENV VITE_CLERK_PUBLISHABLE_KEY=${VITE_CLERK_PUBLISHABLE_KEY}
WORKDIR /app
COPY /frontend/package*.json  ./
RUN  npm install
COPY /frontend ./
RUN npm run build

FROM node:20-alpine AS api
WORKDIR /app
COPY backend/package*.json ./
RUN npm install --omit-dev
COPY /backend .

FROM node:20-alpine AS server
ENV NODE_ENV=${NODE_ENV}
WORKDIR /app
COPY package* ./
#RUN npm install --omit-dev
COPY --from=ui ./app/dist ./frontend/dist
COPY --from=api ./app ./backend
EXPOSE 3000
CMD [ "npm", "start" ]