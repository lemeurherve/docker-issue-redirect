# docker-issue-redirect

A simple service for redirecting issues to GitHub if they've been migrated or Jira if they haven't been.

The script [redirect.sh](./bin/redirects.sh) takes a file [jira_keys_to_github_ids.txt](./mappings/jira_keys_to_github_ids.txt) and generates nginx redirect directives.

A default rule will redirect any unknown issue IDs to Jira.

## API

- `GET /:jira_key` - Redirects to the corresponding GitHub issue, if found. Otherwise to Jira.
- `GET /issue/:jira_key_id` - Redirects to the corresponding GitHub issue, if found. Otherwise to Jira prefixing it with `JENKINS-`. (Kept for compatibility with existing uses)

Ex:
- `https://issue-redirect.jenkins.io/JENKINS-1`
- `https://issue-redirect.jenkins.io/INFRA-1`
- `https://issue-redirect.jenkins.io/issue/1`

## Adding more

To add more Jira redirects send a pull request to [jira_keys_to_github_ids.txt](./mappings/jira_keys_to_github_ids.txt).

To add redirections for issues of another Jira project than the ones already included, you'll also have to update [redirect.sh](./redirect.sh)
