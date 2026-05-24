# ========================================================
# STAGE 1: React & TypeScript Compiler
# ========================================================
FROM node:20-alpine AS compiler

WORKDIR /app

# Copy dependency manifests first for caching
COPY package*.json ./

# Install packages
RUN npm install

# Copy the rest of the React source code
COPY . .

# Compile React/TypeScript to static production HTML/JS/CSS assets
# Outputs built assets to the '/app/dist' folder
RUN npm run build

# ========================================================
# STAGE 2: High-Performance Production Nginx Server
# ========================================================
FROM nginx:1.25-alpine

WORKDIR /usr/share/nginx/html

# Clean out default Nginx static files
RUN rm -rf ./*

# Copy compiled static assets from the builder stage
COPY --from=compiler /app/dist .

# Copy custom Nginx proxy configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose HTTP port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
