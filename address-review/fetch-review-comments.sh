#!/usr/bin/env bash
# Fetch all inline review comments for a PR.
#
# Usage: fetch-review-comments.sh <owner/repo> <pr_number>
#
# Outputs one block per comment, separated by "---", with fields:
#   ID, File, Line, Author, Body
#
# Example:
#   fetch-review-comments.sh Alcova-AI/operator-ui 314

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <owner/repo> <pr_number>" >&2
  exit 1
fi

repo="$1"
pr_number="$2"

gh api "repos/${repo}/pulls/${pr_number}/comments" --paginate --jq '.[] | "---\nID: \(.id)\nFile: \(.path):\(.line // .original_line)\nAuthor: \(.user.login)\nBody: \(.body)\n"'
