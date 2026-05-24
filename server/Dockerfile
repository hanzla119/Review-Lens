# ========================================================
# STAGE 1: Build & Compile Native Dependencies
# ========================================================
FROM node:20-alpine AS builder

WORKDIR /usr/src/app

# Install build dependencies for native C++ modules (like bcrypt)
RUN apk add --no-cache make gcc g++ python3

# Copy root dependency manifests
COPY package*.json ./

# Run a full install (which compiles C++ packages successfully now!)
RUN npm install

# Copy the entire workspace
COPY . .

# ========================================================
# STAGE 2: Production Execution (Zero Installation Stage)
# ========================================================
FROM node:20-alpine AS runner

WORKDIR /usr/src/app

ENV NODE_ENV=production
ENV PORT=8080

# Copy all compiled code and modules from the builder stage
# Bypasses the need to run npm install in the runner stage!
COPY --from=builder /usr/src/app .

# Drop root privileges for safety
USER node
EXPOSE 8080

# Run your index.js from its correct subfolder location
CMD ["node", "server/src/index.js"]
