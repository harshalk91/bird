deploy() {
    local APP_NAME="$1"
    local ENVIRONMENT="$2"
    local DEPLOYMENT_FILE="../${APP_NAME}/deploy/${ENVIRONMENT}/${APP_NAME}_deployment.yaml"

    # Check if the deployment file exists
    if [[ ! -f "$DEPLOYMENT_FILE" ]]; then
        echo "Error: Deployment file not found at path: $DEPLOYMENT_FILE"
        return 1
    else
        kubectl apply -f $DEPLOYMENT_FILE
    fi
}

# ---- Main ----

if [[ $# -lt 2 ]]; then
    echo "❌ Usage: $0 <APP_NAME> <ENVIRONMENT>"
    exit 1
fi


APP_NAME="$1"
ENVIRONMENT="$2"

deploy "$APP_NAME" "$ENVIRONMENT"