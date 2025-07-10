# syntax=docker/dockerfile:1
FROM node:18-alpine AS base
WORKDIR /app

# Install dependencies (production)
COPY package*.json ./
RUN npm ci --only=production

# Copy application code
COPY . .

# Copy configuration templates if missing
RUN cp -n .env.dist .env || true
RUN cp -n knexfile.js.dist knexfile.js || true

# Expose application port
EXPOSE 8080

# Default environment (can be overridden in docker-compose or runtime)
ENV RELDENS_ALLOW_RUN_BUNDLER=1 \
    RELDENS_DB_CLIENT=mysql \
    RELDENS_DB_HOST=db \
    RELDENS_DB_PORT=3306 \
    RELDENS_DB_NAME=reldens_demo \
    RELDENS_DB_USER=reldens \
    RELDENS_DB_PASSWORD=reldens

CMD ["npm", "start"]