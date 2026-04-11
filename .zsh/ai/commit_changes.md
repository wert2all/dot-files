Generate a commit message following the Conventional Commits specification and commit the changes.

## Workflow
  1. Analyze the current changes using `git status` and `git diff`
  2. Generate a commit message following the Conventional Commits specification
  3. Commit the changes

# Important
- Do NOT stage or add any files
- Do NOT commit files that likely contain secrets (.env, credentials.json, etc.)
- Do NOT run destructive commands like `git push --force` or hard resets
- If there are no staged files, write a warning message to the user and do nothing
