#!/bin/bash

# Check if the PAT is available
if [ -z "$PAT" ]; then
  echo "Personal Access Token not provided. Set the PAT environment variable."
  exit 1
fi

# Fetch the runner token from GitHub API
REGISTRATION_TOKEN=$(curl -sX POST -H "Authorization: token $PAT" "https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/registration-token" | jq -r '.token')

# Exit if unable to fetch token
if [ -z "$REGISTRATION_TOKEN" ]; then
  echo "Failed to fetch registration token"
  exit 1
fi

# Dynamically generate the RUNNER_NAME
RUNNER_NAME="$POD_NAME-$NODE_NAME"

echo "Runner Name: $RUNNER_NAME"

# Configure the GitHub Actions Runner
echo "Registering the GitHub Runner..."
./config.sh --url "https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}" \
            --token "$REGISTRATION_TOKEN" \
            --name "$RUNNER_NAME" \
            --labels "$RUNNER_LABELS" \
            --unattended --replace
echo "Runner registered successfully."

# Run the GitHub Actions Runner
echo "Starting GitHub Runner..."
exec "./run.sh"
