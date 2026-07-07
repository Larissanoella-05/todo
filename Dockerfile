#  Stage 1: base 
FROM node:18-alpine AS base
WORKDIR /app
COPY backend/package*.json ./
RUN npm install --ignore-scripts=false
COPY backend/ .

#  Stage 2: dev
FROM base AS dev
RUN npm install -g nodemon
EXPOSE 3000
CMD ["nodemon", "src/index.js"]

# Stage 3: frontend-dev
FROM node:18-alpine AS frontend-dev
WORKDIR /client
COPY client/package*.json ./
RUN npm install --ignore-scripts=false
COPY client/ .
EXPOSE 5173
CMD ["npm", "run", "dev"]

# Stage 4: test
FROM base AS test
RUN npm test

# Stage 5: frontend-build
FROM node:18-alpine AS frontend-build
WORKDIR /client
COPY client/package*.json ./
RUN npm install --ignore-scripts=false
COPY client/ .
RUN npm run build

# Stage 6: final
FROM node:18-alpine AS final
WORKDIR /app
COPY --from=test /app/package.json ./
COPY --from=test /app/package-lock.json ./
RUN npm install --only=production --ignore-scripts=false
COPY --from=test /app/src ./src
COPY --from=frontend-build /client/dist ./src/static
EXPOSE 3000
CMD ["node", "src/index.js"]