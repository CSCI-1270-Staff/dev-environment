FROM golang:1.21-alpine

# Set working directory
WORKDIR /app

# Install Go dependencies.
COPY ./go.mod ./go.sum ./
RUN go mod download && go mod verify

# Copy files.
COPY . .

# Build bumblebase
RUN go build ./cmd/bumble

# Enable the following past the Concurrency assignment.
# RUN go build ./cmd/bumble_client

# Run.
CMD ["/bin/sh"]