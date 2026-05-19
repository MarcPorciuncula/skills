#!/usr/bin/env bash
# Resolve PR review threads, filtered to only threads whose root comment ID
# is in the provided allow-list.
#
# Usage: resolve-threads.sh <owner/repo> <pr_number> <file>
#
# The file should contain one comment ID per line. Empty lines and lines
# starting with # are skipped.
#
# The script fetches all review threads, matches each thread's root comment
# databaseId against the IDs in the file, and only resolves matching threads.
# This prevents accidentally resolving threads from newer reviews.
#
# Example file contents:
#   2979303473
#   2979303494
#   2979303512
#
# Example:
#   resolve-threads.sh owner/repo 314 ids.txt

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

owner="${repo%%/*}"
repo_name="${repo##*/}"

# Collect allowed comment IDs into a space-delimited string for lookup
allowed_ids=" "
while IFS= read -r line; do
  [[ -z "$line" || "$line" == \#* ]] && continue
  allowed_ids+="$line "
done < "$file"

# Fetch all review threads with their root comment databaseId
threads_json=$(gh api graphql -f query="
  query {
    repository(owner: \"${owner}\", name: \"${repo_name}\") {
      pullRequest(number: ${pr_number}) {
        reviewThreads(first: 100) {
          nodes {
            id
            isResolved
            comments(first: 1) {
              nodes {
                databaseId
              }
            }
          }
        }
      }
    }
  }
")

resolved=0
skipped=0

# Parse and resolve matching threads
while IFS=$'\t' read -r thread_id is_resolved comment_db_id; do
  if [[ "$is_resolved" == "true" ]]; then
    continue
  fi

  if [[ "$allowed_ids" != *" ${comment_db_id} "* ]]; then
    skipped=$((skipped + 1))
    continue
  fi

  if gh api graphql -f query="mutation { resolveReviewThread(input: {threadId: \"${thread_id}\"}) { thread { isResolved } } }" > /dev/null 2>&1; then
    echo "Resolved thread ${thread_id} (comment ${comment_db_id})"
    resolved=$((resolved + 1))
  else
    echo "FAILED to resolve thread ${thread_id}" >&2
  fi
done < <(echo "$threads_json" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for node in data['data']['repository']['pullRequest']['reviewThreads']['nodes']:
    tid = node['id']
    resolved = str(node['isResolved']).lower()
    cid = node['comments']['nodes'][0]['databaseId']
    print(f'{tid}\t{resolved}\t{cid}')
")

echo "Done: ${resolved} resolved, ${skipped} skipped (not in allow-list)"
