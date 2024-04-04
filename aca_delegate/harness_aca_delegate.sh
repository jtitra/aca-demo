#ACA Delegate Setup

#environment
APP_NAME=aca-delegate
APP_ENVIRONMENT_NAME=aca-delegate-env
APP_LOG_WORKSPACE_NAME=aca-delegate-log-workspace
RESOURCE_GROUP=aca-demo-rg
LOCATION=eastus2

#harness delegate
HARNESS_ACCOUNT_ID=6_vVHzo9Qeu9fXvj-AcbCQ
HARNESS_DELEGATE_NAME=$APP_NAME
HARNESS_DELEGATE_IMAGE="jtitra/azure-delegate"
HARNESS_DELEGATE_VERSION="24.03.82600"
HARNESS_NEXT_GEN="true"
HARNESS_DELEGATE_TYPE="DOCKER"
HARNESS_DELEGATE_TOKEN=ZjQ3ZDA4MzkyxxxxxxxxxxxxxxxxxxxxNzhlYjMzMGU=
HARNESS_DELEGATE_TAGS=""
HARNESS_LOG_STREAMING_SERVICE_URL="https://app.harness.io/gratis/log-service/"
HARNESS_MANAGER_HOST_AND_PORT="https://app.harness.io/gratis"

#create a log analytics workspace
az monitor log-analytics workspace create \
    --name $APP_LOG_WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION

log_id=$(az monitor log-analytics workspace show \
    --name $APP_LOG_WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    | jq -r ".customerId")

log_key=$(az monitor log-analytics workspace get-shared-keys \
    --name $APP_LOG_WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    | jq -r ".primarySharedKey")

#create container app environment
az containerapp env create \
    --name $APP_ENVIRONMENT_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --logs-workspace-id $log_id \
    --logs-workspace-key $log_key

#create container app
az containerapp create \
  --name $APP_NAME \
  --environment $APP_ENVIRONMENT_NAME \
  --resource-group $RESOURCE_GROUP \
  --cpu 1 \
  --memory 2.0Gi \
  --image $HARNESS_DELEGATE_IMAGE \
  --env-vars DELEGATE_NAME="$HARNESS_DELEGATE_NAME" NEXT_GEN="$HARNESS_NEXT_GEN" DELEGATE_TYPE="$HARNESS_DELEGATE_TYPE" ACCOUNT_ID=$HARNESS_ACCOUNT_ID DELEGATE_TOKEN=$HARNESS_DELEGATE_TOKEN DELEGATE_TAGS="$HARNESS_DELEGATE_TAGS" LOG_STREAMING_SERVICE_URL="$HARNESS_LOG_STREAMING_SERVICE_URL" MANAGER_HOST_AND_PORT="$HARNESS_MANAGER_HOST_AND_PORT"


