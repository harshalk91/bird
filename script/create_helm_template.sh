create_helm_template() {
    local APP_NAME="$1"
    local IMAGE_NAME="$2"
    local ENVIRONMENT="$3"
    local IMAGE_SHA="sha-$(git rev-parse --short HEAD)"

    echo "📁 Moving to Helm chart directory"
    cd "../../application-helm/stable"

    echo "🛠️ Generating Helm template for ${APP_NAME} in ${ENVIRONMENT} environment"
    helm template \
        --skip-tests \
        -f "../../../${APP_NAME}/deploy/${ENVIRONMENT}/values.yaml" \
        --set "deployment.image.tag=${IMAGE_SHA}" \
        -n "${APP_NAME}" "${APP_NAME}" ./ > "../../../${APP_NAME}/deploy/${ENVIRONMENT}/${APP_NAME}_deployment.yaml"

    echo "✅ Helm template generated at ../../../${APP_NAME}/deploy/${ENVIRONMENT}/${APP_NAME}_deployment.yaml"
    cat ../../../${APP_NAME}/deploy/${ENVIRONMENT}/${APP_NAME}_deployment.yaml
    cd ../../../script
}


# ---- Main ----

if [[ $# -lt 3 ]]; then
    echo "❌ Usage: $0 <APP_NAME> <IMAGE_NAME> <ENVIRONMENT>"
    exit 1
fi

APP_NAME="$1"
IMAGE_NAME="$2"
ENVIRONMENT="$3"

create_helm_template "$APP_NAME" "$IMAGE_NAME" "$ENVIRONMENT"