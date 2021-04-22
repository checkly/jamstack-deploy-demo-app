#!/bin/bash

set -e

npm run build

S3_BUCKET=s3.jamstackdeploy.com
CLOUDFRONT_DISTRIBUTION=E3ONGY9MOZ911M

echo "🗄 Uploading files to bucket: ${S3_BUCKET}"
aws s3 cp \
  --recursive \
  --acl public-read \
  --region us-east-1 \
  ./dist/ s3://"${S3_BUCKET}"

echo "🗑 Invalidate cloud front distribution cache: ${CLOUDFRONT_DISTRIBUTION}"
aws configure set preview.cloudfront true
aws cloudfront create-invalidation --distribution-id "${CLOUDFRONT_DISTRIBUTION}" --paths "/*"