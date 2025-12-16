#!/usr/bin/env bash

set -euo pipefail

REDIRECTS_FILE="jira-to-github-redirects.conf"

MAPPINGS_FILE="mappings/jira_keys_to_github_ids.txt"

# Clear or create the redirects file
> "$REDIRECTS_FILE"

# Process each line
while IFS=: read -r jira_key github_ref; do
  # JENKINS project
  if [[ $jira_key =~ JENKINS-([0-9]+) ]]; then
    issue_num="${BASH_REMATCH[1]}"

    # Extract the repo path and issue number from github_ref (e.g., jenkinsci/jenkins#13336)
    if [[ $github_ref =~ (.+)#([0-9]+) ]]; then
      repo_path="${BASH_REMATCH[1]}"
      github_issue="${BASH_REMATCH[2]}"

      echo "rewrite ^/issue/$issue_num$ https://github.com/$repo_path/issues/$github_issue permanent;" >> "$REDIRECTS_FILE"
      echo "rewrite ^/JENKINS-$issue_num$ https://github.com/$repo_path/issues/$github_issue permanent;" >> "$REDIRECTS_FILE"
    fi
  fi
  # INFRA project
  if [[ $jira_key =~ INFRA-([0-9]+) ]]; then
    issue_num="${BASH_REMATCH[1]}"
    
    # Extract the repo path and issue number from github_ref (e.g., jenkins-infra/helpdesk#83
    if [[ $github_ref =~ (.+)#([0-9]+) ]]; then
      repo_path="${BASH_REMATCH[1]}"
      github_issue="${BASH_REMATCH[2]}"

      echo "rewrite ^/INFRA-$issue_num$ https://github.com/$repo_path/issues/$github_issue permanent;" >> "$REDIRECTS_FILE"
    fi
  fi
done < "$MAPPINGS_FILE"

echo "Redirects file generated at $REDIRECTS_FILE"

