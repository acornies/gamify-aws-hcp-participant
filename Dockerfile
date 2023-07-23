FROM golang:1.20 as builder

LABEL maintainer="Andrew Cornies <andrew.cornies@hashicorp.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source from the current directory to the Working Directory inside the container
COPY ./app .

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Build the Go app
RUN CGO_ENABLED=0 go build -o gamify-participant .

FROM public.ecr.aws/lambda/provided:al2

WORKDIR /app

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/gamify-participant .

# Copy the Vault Lambda Extension into specific location
COPY extensions/vault-lambda-extension /opt/extensions/vault-lambda-extension

# Command to run the executable
ENTRYPOINT ["/app/gamify-participant"]