#!/bin/bash

echo $PROJECT_ID
gcloud config set project $PROJECT_ID
triggers=$(gcloud beta builds triggers list | grep build-vpc-trigger)
if [ -z "$triggers" ]; then
gcloud beta builds triggers create github \
--repo-name="basic-vpc" \
--repo-owner="zain-GFT" \
--name="build-vpc-trigger" \
--build-config="vpc/cloudbuild.yaml" \
--branch-pattern=".*"
fi