FROM alpine/curl:8.12.1 AS builder
LABEL description="For deployment markers in Honeycomb from CI/CD pipelines"

# https://docs.docker.com/build/building/variables/#multi-platform-build-arguments
ARG TARGETOS
ARG TARGETARCH

ARG HONEYMARKER_VERSION=v0.2.12
WORKDIR /app
# Prefer a tagged version for determinism.
RUN echo "HONEYMARKER_VERSION=$HONEYMARKER_VERSION TARGETOS=$TARGETOS TARGETARCH=$TARGETARCH" \
  && curl --location --fail "https://github.com/honeycombio/honeymarker/releases/download/$HONEYMARKER_VERSION/honeymarker-$TARGETOS-$TARGETARCH" -o "/app/honeymarker" \
  && chmod +x "/app/honeymarker"

FROM gcr.io/distroless/static-debian12:debug
ENV TZ=UTC
WORKDIR /app
COPY --from=builder /app /app
ENTRYPOINT ["/app/honeymarker"]
