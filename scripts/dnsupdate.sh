#!/bin/bash

# Set default TTL value if not set in environment
TTL=${TTL:-300}

# Set default check interval if not set in environment
CHECK_INTERVAL=${CHECK_INTERVAL:-1600}

# Set default service account folder if not set in environment
SERVICE_ACCOUNT_FOLDER=${SERVICE_ACCOUNT_FOLDER:-/scripts/serviceaccounts}

# Validate ZONE_NAME variable
if [[ -z "$ZONE_NAME" ]]; then
  echo "ZONE_NAME environment variable is not set. Please set it to the name of your Google Cloud DNS zone."
  exit 1
fi

# Validate RECORD_NAME variable
if [[ -z "$RECORD_NAME" ]]; then
  echo "RECORD_NAME environment variable is not set. Please set it to the name of the A record you want to update."
  exit 1
fi

# Activate Google service account
if [[ -n "$SERVICE_ACCOUNT_FILE" ]]; then
  gcloud auth activate-service-account --key-file="$SERVICE_ACCOUNT_FILE"
else
  SERVICE_ACCOUNT_FILE=$(find "$SERVICE_ACCOUNT_FOLDER" -maxdepth 1 -type f -name '*.json' | head -n 1)
  gcloud auth activate-service-account --key-file="$SERVICE_ACCOUNT_FILE"
fi

if [ -z "$PROJECT_ID" ]; then
  echo "Error: PROJECT_ID environment variable not set"
  exit 1
fi

gcloud config set project $PROJECT_ID 

while true; do
  # Get current public IP address
  PUBLIC_IP=$(curl -s http://checkip.amazonaws.com)

  # Get current DNS record IP address
  CURRENT_IP=$(gcloud dns record-sets list --name="$RECORD_NAME" --type=A --zone="$ZONE_NAME" --format="value(rrdatas[0])")

  if [[ "$PUBLIC_IP" != "$CURRENT_IP" ]]; then
    echo "IP address has changed. Updating DNS record."
    # Update Google Cloud DNS A record
    gcloud dns record-sets transaction start --zone="$ZONE_NAME"
    gcloud dns record-sets transaction remove --name="$RECORD_NAME" --ttl="$TTL" --type=A --zone="$ZONE_NAME" "$CURRENT_IP"
    gcloud dns record-sets transaction add "$PUBLIC_IP" --name="$RECORD_NAME" --ttl="$TTL" --type=A --zone="$ZONE_NAME"
    gcloud dns record-sets transaction execute --zone="$ZONE_NAME"
  else
    echo "IP address has not changed."
  fi

  # Echo sleep duration
  echo "Sleeping for $CHECK_INTERVAL seconds..."

  # Wait for the next check interval
  sleep "$CHECK_INTERVAL"
done

