#!/bin/sh -l

# Exit immediately if a command exits with a non-zero status
set -e

SOURCE_DIR=$1
API_TOKEN=$2
INDEX_FILE_PATH="${SOURCE_DIR}/index.html"

if [ -z "$SOURCE_DIR" ]; then
  echo "SOURCE_DIR is required. e.g. ./build_production or ./output"
  exit 1
fi

if [ -z "$API_TOKEN" ]; then
  echo "API_TOKEN is required - Get your FREE API token at https://www.gostaticapp.com"
  exit 1
fi

if ! test -f "$INDEX_FILE_PATH"; then
  echo "Warning - index.html is missing"
fi

tar -czf artifact.tar.gz -C $SOURCE_DIR .

echo "Uploading. This might take a while..."

http_response_code=$(curl --silent --write-out "%{http_code}" --output response.txt \
  -X POST \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -F "file=@artifact.tar.gz" \
  https://www.gostaticapp.com/api/deploy/artifact)

response_content=$(cat response.txt)

content_deployment_id=$(echo $response_content | jq -r '.deployment_id')
content_message=$(echo $response_content | jq -r '.message')
content_error=$(echo $response_content | jq -r '.error')
content_status=$(echo $response_content | jq -r '.status')
content_url=$(echo $response_content | jq -r '.url')

rm artifact.tar.gz
rm response.txt

if [[ "$http_response_code" != "201" ]]; then
  echo "Code:$http_response_code\nMessage:$content_message\nError:$content_error"
  exit 1
fi

# Return these values to the action
echo "::set-output name=deployment_id::$content_deployment_id"
echo "::set-output name=url::$content_url"

echo "Deployment successful!"
echo $response_content | jq -r