#! /bin/bash

gcloud functions deploy crawler \
    --gen2 \
    --region asia-northeast1 \
    --runtime python39 \
    --allow-unauthenticated \
    --trigger-http \
    --project=umeda-service-sandbox-1992