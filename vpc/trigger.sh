#!/bin/bash

echo $PROJECT_ID
gcloud config set project $PROJECT_ID
triggers=$(gcloud beta builds triggers list | grep build-log-bucket-trigger)
if [ -z "$triggers" ]; then
gcloud beta builds triggers create github \
--repo-name="basic-vpc" \
--repo-owner="zain-GFT" \
--name="build-log-bucket-trigger" \
--build-config="vpc/cloudbuild.yaml" \
--branch-pattern=".*"
fi