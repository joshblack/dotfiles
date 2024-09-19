#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title GitHub Integration Test
# @raycast.mode fullOutput
#
# Optional parameters:
# @raycast.icon 🔬
# @raycast.packageName joshblack/dotfiles
# @raycast.argument1 { "type": "text", "placeholder": "Pull Request", "optional": false }

echo "Getting canary version..."
VERSION=$(gh pr checks $1 --json name,description --jq '.[] | select(.name == "Published @primer/react").description')

if [[ $VERSION ]]; then
  echo "Running workflow..."
  gh workflow run primer-react-pr-test.yml -R github/github --field prc-pr="$1" --field version="$VERSION"

  echo "Getting workflow run..."
  sleep 3
  WORKFLOW_RUN="$(gh run list --workflow=primer-react-pr-test.yml -R github/github --json url -q '.[0].url')"

  echo "Workflow run: $WORKFLOW_RUN"
else
  echo 'No canary version found'
fi
