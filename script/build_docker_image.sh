#!/bin/bash
set -euo pipefail

docker_build_scan() {    
    local APP_NAME="$1"
    local IMAGE_NAME="$2"
    local IMAGE_SHA="sha-$(git rev-parse --short HEAD)"

    echo "📁 Moving to app directory: ../$APP_NAME"
    cd "../$APP_NAME"

    echo "🚀 Building Docker image: $IMAGE_NAME:$IMAGE_SHA"
    docker build -t "${IMAGE_NAME}:${IMAGE_SHA}" .

    echo "🔎 Scanning Docker image with Trivy..."
    trivy image \
        --exit-code 1 \
        --scanners vuln,misconfig,secret,license \
        --severity CRITICAL \
        "${IMAGE_NAME}:${IMAGE_SHA}"

    echo "✅ Pushing Docker image: ${IMAGE_NAME}:${IMAGE_SHA}"
    docker push "${IMAGE_NAME}:${IMAGE_SHA}"

    echo "✅ Docker build and security scan completed successfully!"
}

# ---- Main ----

if [[ $# -lt 3 ]]; then
    echo "❌ Usage: $0 <APP_NAME> <IMAGE_NAME> <ENVIRONMENT>"
    exit 1
fi

APP_NAME="$1"
IMAGE_NAME="$2"
ENVIRONMENT="$3"

docker_build_scan "$APP_NAME" "$IMAGE_NAME"