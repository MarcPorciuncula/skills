#!/usr/bin/env bash
# Fetch all review statuses for a PR.
#
# Usage: fetch-reviews.sh <owner/repo> <pr_number>
#
# Outputs one block per review, separated by "---", with fields:
#   Author, State, Body
#
# Example:
#   fetch-reviews.sh Alcova-AI/operator-ui 314

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <owner/repo> <pr_number>" >&2
  exit 1
fi

repo="$1"
pr_number="$2"

gh api "repos/${repo}/pulls/${pr_number}/reviews" --paginate --jq '.[] | "---\nAuthor: \(.user.login)\nState: \(.state)\nBody: \(.body)\n"'
