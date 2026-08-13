# SETUP.md — Bootstrap a new project with another LLM

Give the prompt below to any capable LLM (Claude Code, opencode, Codex, etc.)
to configure a new project with the agent-dotfiles system in one shot: it
clones the repo, installs the skills and the opencode memory plugin, copies the
files a new project needs, and runs the onboarding — no manual steps.

## One-liner (LLM can read the repo)

```
Read https://github.com/thenickz/agent-dotfiles/blob/main/SETUP.md and follow
it in <target-project-directory>.
```

## Self-contained prompt (LLM cannot read the repo)

```
You are setting up a new project with the agent-dotfiles knowledge system
(AGENTS.md + memory.md + architecture.md) in <target-project-directory>.

1. Clone https://github.com/thenickz/agent-dotfiles into a temp directory
   (or read it online).
2. From that clone, run `./install.sh` to install the skills (global symlinks)
   and the opencode memory enforcement plugin. It is idempotent and never
   overwrites existing config — running it when already installed is fine.
3. In <target-project-directory>:
   a. Run `git init` if it is not already a git repo.
   b. Copy `templates/AGENTS.md` from the clone to the project root.
   c. Create `memory.md` and `architecture.md` (run the scaffold-agents-md
      skill, or build them by hand, tailored to the project).
   d. Copy `templates/ONBOARDING.md` from the clone to the project root.
4. Run the onboarding now: follow the steps in ONBOARDING.md (analyze the
   project, verify the documented commands, ask the user only the essentials,
   record the bootstrap in memory.md), then delete ONBOARDING.md.
5. Report what was installed, what was scaffolded, and anything the user still
   needs to do (e.g. first commit, git remote).

Do not modify the agent-dotfiles clone. Remove the temp clone when done.
```
