#! /bin/bash

gcloud functions deploy ruby_crawler \
    --gen2 \
    --region asia-northeast1 \
    --runtime=ruby32 \
    --allow-unauthenticated \
    --trigger-http \
    --project=umeda-service-sandbox-1992