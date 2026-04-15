# Multi-stage build for React application
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Build stage for React frontend
FROM base AS build-frontend
COPY src/ ./src/
COPY public/ ./public/
COPY index.html ./
COPY vite.config.* ./
COPY tsconfig*.json ./
RUN npm run build

# Production stage
FROM base AS production
COPY --from=build-frontend /app/dist ./dist/
COPY server/ ./server/

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
