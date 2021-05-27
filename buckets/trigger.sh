#!/bin/bash

gcloud config set project $PROJECT_ID
triggers=$(gcloud beta builds triggers list | grep build-log-bucket-trigger)
if [ -z "$triggers" ]; then
gcloud beta builds triggers create github \
--repo-name="basic-vpc" \
--repo-owner="zain-GFT" \
--name="build-log-bucket-trigger" \
--build-config="buckets/cloudbuild.yaml" \
--branch-pattern=".*" \
--included-files="buckets/*"
fi