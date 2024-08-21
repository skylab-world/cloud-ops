# Stage 1: Build and Test
FROM ubuntu:20.04 AS builder

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    build-essential \
    openjdk-11-jdk-headless \
    python3 \
    python3-distutils \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Install Bazelisk manually
RUN curl -L https://github.com/bazelbuild/bazelisk/releases/download/v1.20.0/bazelisk-linux-amd64 -o /usr/local/bin/bazelisk && \
    chmod +x /usr/local/bin/bazelisk

WORKDIR /app

# Copy the entire project
COPY . .

# Run Bazel tests
RUN /usr/local/bin/bazelisk test //...

# Build the application using Bazel
RUN /usr/local/bin/bazelisk build //cmd:cloud-ops

# Stage 2: Production
FROM alpine:3.18

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/bazel-bin/cmd/cloud-ops/cloud-ops .

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./cloud-ops"]