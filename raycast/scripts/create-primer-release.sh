#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create Primer Release Pull Request
# @raycast.mode compact
#
# Optional parameters:
# @raycast.icon 🌀
# @raycast.packageName joshblack/dotfiles


echo "Getting Release Tracking Pull Request..."
RELEASE_TRACKING_PR="$(gh pr list -R primer/react -q '.[] | select(.title | startswith("Release tracking")).url' --json title,url)"

echo "Running workflow dispatch..."
gh workflow run primer-release.yml -R github/github --field release_pr="$RELEASE_TRACKING_PR"

echo "Getting workflow run..."
sleep 3
WORKFLOW_RUN="$(gh run list --workflow=primer-release.yml -R github/github --json url -q '.[0].url')"

echo "Opening in Browser..."
open -a "Google Chrome" "$WORKFLOW_RUN"
