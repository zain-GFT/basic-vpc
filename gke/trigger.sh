#!/bin/bash

gcloud config set project $PROJECT_ID
triggers=$(gcloud beta builds triggers list | grep build-gke-trigger)
if [ -z "$triggers" ]; then
gcloud beta builds triggers create github \
--repo-name="iac-orchestration-dev-proj" \
--repo-owner="CPT-CE" \
--name="build-gke-trigger" \
--build-config="gke/cloudbuild.yaml" \
--branch-pattern=".*" \
--included-files="gke/*"
fi
