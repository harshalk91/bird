FROM golang:1.24.2-alpine3.21 as builder

RUN apk update && apk add --no-cache make bash

WORKDIR /app

COPY . .

RUN make birdImage

# stage 2 
FROM alpine:3.19

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=builder /app .

RUN chown -R appuser:appgroup /app

VOLUME ["/tmp"]

RUN chmod 1777 /tmp

ENTRYPOINT ["/app/getBirdImage"]

USER appuser

EXPOSE 4200