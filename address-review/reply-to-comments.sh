#!/usr/bin/env bash
# Reply to multiple PR review comments in one invocation.
#
# Usage: reply-to-comments.sh <owner/repo> <pr_number> <file>
#
# The file should contain one reply per line in the format:
#   comment_id:body
# where the delimiter is the FIRST colon. The body should already include
# the [Claude] prefix. Empty lines and lines starting with # are skipped.
#
# Example file contents:
#   12345:[Claude] Fixed — added nil guard.
#   67890:[Claude] Not applicable — React 19 handles this natively.
#
# Example:
#   reply-to-comments.sh owner/repo 314 replies.txt

set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "Usage: $0 <owner/repo> <pr_number> <file>" >&2
  exit 1
fi

repo="$1"
pr_number="$2"
file="$3"

if [[ ! -f "$file" ]]; then
  echo "Error: file not found: $file" >&2
  exit 1
fi

replied=0
failed=0

while IFS= read -r line; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" == \#* ]] && continue

  comment_id="${line%%:*}"
  body="${line#*:}"

  if gh api "repos/${repo}/pulls/${pr_number}/comments/${comment_id}/replies" -f body="${body}" > /dev/null 2>&1; then
    echo "Replied to comment ${comment_id}"
    replied=$((replied + 1))
  else
    echo "FAILED to reply to comment ${comment_id}" >&2
    failed=$((failed + 1))
  fi
done < "$file"

echo "Done: ${replied} replied, ${failed} failed"
