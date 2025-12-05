#!/bin/bash
# Usage: get-kubeconfig.sh <resource-group> <cluster-name> [kubeconfig-output-file]
RESOURCE_GROUP="$1"
CLUSTER_NAME="$2"
OUT_FILE="$3"

if [ -z "$RESOURCE_GROUP" ] || [ -z "$CLUSTER_NAME" ]; then
  echo "Usage: $0 <resource-group> <cluster-name> [kubeconfig-output-file]"
  exit 1
fi

if [ -n "$OUT_FILE" ]; then
  az aks get-credentials \
    --resource-group "$RESOURCE_GROUP" \
    --name "$CLUSTER_NAME" \
    --file "$OUT_FILE" \
    --overwrite-existing
else
  az aks get-credentials \
    --resource-group "$RESOURCE_GROUP" \
    --name "$CLUSTER_NAME" \
    --overwrite-existing
fi
