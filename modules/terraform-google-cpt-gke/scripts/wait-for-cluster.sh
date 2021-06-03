#!/bin/bash
set -e

# shellcheck disable=SC2034
if [ -n "${GOOGLE_APPLICATION_CREDENTIALS}" ]; then
    export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE="${GOOGLE_APPLICATION_CREDENTIALS}"
fi

PROJECT=$1
CLUSTER_NAME=$2

echo "Waiting for cluster $CLUSTER_NAME in project $PROJECT to reconcile..."

while
  ((c++)) && ((c==120)) && break #Break after 10 minutes
  current_status=$(gcloud container clusters list --project="$PROJECT" --filter=name:"$CLUSTER_NAME" --format="value(status)")
  [[ "${current_status}" != "RUNNING" ]]
do printf ".";sleep 5; done

echo "Cluster is ready!"