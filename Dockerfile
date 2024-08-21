# Stage 1: Build and Test
FROM ubuntu:20.04 as builder

# Install Bazelisk and other dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    build-essential \
    openjdk-11-jdk-headless \
    python3 \
    python3-distutils \
    bazelisk \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the entire project
COPY . .

# Run Bazel tests
RUN bazelisk test //...

# Build the application using Bazel
RUN bazelisk build //cmd:cloud-ops

# Stage 2: Production
FROM alpine:3.18

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/bazel-bin/cmd/cloud-ops .

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./cloud-ops"]