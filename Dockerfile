FROM node:20-alpine AS ui
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
WORKDIR /app
COPY package* ./
#RUN npm install --omit-dev
COPY --from=ui ./app/dist ./frontend/dist
COPY --from=api ./app ./backend
EXPOSE 3000
CMD [ "npm", "start" ]