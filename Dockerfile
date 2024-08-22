# Use the official Go image as the base image
FROM golang:1.21-bullseye AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . /app

# Run tests
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go test -v ./...

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o cloud-ops ./cmd

# Start a new stage from scratch
FROM alpine:latest  

# Install ca-certificates for HTTPS
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the pre-built binary file from the previous stage
COPY --from=builder /app/cloud-ops .

# Command to run the application
CMD ["./cloud-ops"]