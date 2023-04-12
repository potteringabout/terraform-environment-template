




GitHub Repo id

Can eb  found with script

```bash
#!/bin/bash
OWNER='your github username or organization name'
REPO_NAME='your repository name'    
echo $(gh api -H "Accept: application/vnd.github+json" repos/$OWNER/$REPO_NAME) | jq .id
```
## Secrets

https://docs.github.com/en/rest/actions/secrets?apiVersion=2022-11-28



# GitHub CLI api
# https://cli.github.com/manual/gh_api

gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repositories/REPOSITORY_ID/environments/ENVIRONMENT/secrets

gh api -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" /repositories/625481833/environments/prod/secrets