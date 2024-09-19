#!/bin/bash

# Create GitHub Codespace
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Create GitHub Codespace
# @raycast.mode compact
#
# Optional parameters:
# @raycast.icon https://github.githubassets.com/favicons/favicon.svg
# @raycast.packageName joshblack/dotfiles

echo "Creating codespace..."
gh cs create -R github/github -b master --default-permissions --devcontainer-path .devcontainer/devcontainer.json -m largePremiumLinux | xargs gh cs code -c
echo "Complete! Opening VSCode now"
