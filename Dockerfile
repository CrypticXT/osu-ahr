# Stage 1: Build Stage
FROM node:18-alpine AS builder

# Set the working directory inside the container
WORKDIR /opt/osuahr

# Copy package.json, package-lock.json, and tsconfig.json to the working directory
COPY package.json package-lock.json tsconfig.json ./

# Install dependencies
RUN npm install

# Copy the source code
COPY src/ src/

# Build the TypeScript code
RUN npm run build

# Stage 2: Production Stage
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /opt/osuahr

# Copy the built application from the builder stage
COPY --from=builder /opt/osuahr/dist /opt/osuahr/dist
COPY --from=builder /opt/osuahr/node_modules /opt/osuahr/node_modules
COPY --from=builder /opt/osuahr/package.json /opt/osuahr/package.json
COPY --from=builder /opt/osuahr/config /opt/osuahr/config

# Expose the desired port
EXPOSE 3115

# Set the command to run your CLI tool
ENTRYPOINT ["node", "dist/index.js"]
