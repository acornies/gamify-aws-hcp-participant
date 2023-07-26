FROM golang:1.20 as build
WORKDIR /app
# Copy dependencies list
COPY ./app .
# Build with optional lambda.norpc tag
RUN CGO_ENABLED=0 go build -tags lambda.norpc -o main main.go
# Copy artifacts to a clean image
ARG BUILDARCH
FROM public.ecr.aws/lambda/provided:al2-$BUILDARCH
COPY --from=build /app/main ./main
COPY extensions/vault-lambda-extension /opt/extensions/vault-lambda-extension
ENTRYPOINT [ "./main" ]