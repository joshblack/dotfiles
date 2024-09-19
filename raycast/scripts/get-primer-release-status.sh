#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Primer Release Status
# @raycast.mode inline
#
# Optional parameters:
# @raycast.icon 👾
# @raycast.packageName joshblack/dotfiles

# echo "Getting latest Primer Release..."

NUMBER=$(gh pr list --label prc-release --label primer-release -R github/github --json number --jq '.[0].number')

if [[ $NUMBER ]]; then
  CHECKS=$(gh pr checks $NUMBER -R github/github --json bucket)
  FAIL=$(echo $CHECKS | jq '[.[] | select(.bucket == "fail")] | length')

  if [[ $FAIL -gt 0 ]]; then
    echo -e "\033[31m$FAIL failed\033[0m"
  else
    PASS=$(echo $CHECKS | jq '[.[] | select(.bucket == "pass")] | length')
    PENDING=$(echo $CHECKS | jq '[.[] | select(.bucket == "pending")] | length')
    echo -e "$PASS passed, $PENDING pending"
  fi
else
  echo 'No Pull Request found'
fi
