#!/usr/bin/env bash
# Fetch all inline review comments for a PR.
#
# Usage: fetch-review-comments.sh <owner/repo> <pr_number>
#
# Outputs one block per comment, separated by "---", with fields:
#   ID, Reply to, Created, File, Line, Author, Body
#
# Comments with an empty "Reply to" field are thread roots. Comments with a
# non-empty "Reply to" are replies whose value is the ID of the thread's root.
#
# Example:
#   fetch-review-comments.sh owner/repo 314

set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <owner/repo> <pr_number>" >&2
  exit 1
fi

repo="$1"
pr_number="$2"

gh api "repos/${repo}/pulls/${pr_number}/comments" --paginate --jq '.[] | "---\nID: \(.id)\nReply to: \(.in_reply_to_id // "")\nCreated: \(.created_at)\nFile: \(.path):\(.line // .original_line)\nAuthor: \(.user.login)\nBody: \(.body)\n"'
