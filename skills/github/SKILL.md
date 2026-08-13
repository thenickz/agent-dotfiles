---
name: github
description: Works with GitHub through the gh CLI: repositories, pull requests, issues, releases, Actions, gists. Use when the user asks to create a repo or PR, review a PR, open or list issues, create a release, run or watch GitHub Actions workflows, create a gist, or interact with GitHub in general. Prefer the gh CLI over the raw REST API to avoid rate limits and keep context small.
---

# GitHub via the gh CLI

Always prefer the `gh` CLI (authenticated, context-efficient, avoids raw API rate limits).

## Check authentication

```bash
gh auth status
```

If not authenticated, ask the user to run `gh auth login`.

## Repositories

```bash
gh repo create <name> --public|--private            # new repo
gh repo create <name> --source=. --remote=origin    # repo for the current directory
gh repo clone <owner>/<repo>
gh repo view <owner>/<repo>
```

## Pull Requests

```bash
gh pr create --title "fix(auth): ..." --body "..."  # title in conventional commits
gh pr create --draft                                 # WIP
gh pr view [--web]
gh pr checkout <n>
gh pr review <n> --approve | --comment | --request-changes
gh pr list --author @me
```

## Issues

```bash
gh issue create --title "..." --body "..."
gh issue list --assignee @me
```

Close issues via commit/PR with the footer `Closes #<n>`.

## Releases

```bash
gh release create v1.0.0 --generate-notes --title "..."
gh release list
```

## GitHub Actions

```bash
gh workflow run <name>
gh run watch
gh run list
```

## Gists

```bash
gh gist create <file> [--public]
```

## Conventions and security

- PR titles in conventional commits (see the git-conventional-commits skill).
- Never commit secrets. Before pushing, review `git diff` for tokens/environment files.
- **Ask for human approval BEFORE:** deleting a repository, force-pushing to a shared branch, merging with red CI, changing permissions/branch protections.
