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

REPO='github/github-ui'
echo "Running workflow..."

gh workflow run primer-react-pr-test.yml -R $REPO --field prc-pr="$1"

echo "Getting workflow run..."
sleep 3

WORKFLOW_RUN="$(gh run list --workflow=primer-react-pr-test.yml -R $REPO --json url -q '.[0].url')"

echo "Workflow run: $WORKFLOW_RUN"
