Generate a commit message following the Conventional Commits specification and commit the changes.

# Workflow
1. Analyze the current changes using `git status` and `git diff`
2. Generate a commit message following the format below
3. If there are already staged files, commit them directly with `git commit -m "<message>"`

The commit message should follow this format:
<type>(<scope>): <description>

<optional body>

Where:

- type: feat, fix, docs, style, refactor, perf, test, chore, etc.
- scope: optional, specifies the part of the codebase affected
- description: brief summary of changes
- body: optional, short more detailed explanation

# Important
- Do NOT commit files that likely contain secrets (.env, credentials.json, etc.)
- Do NOT run destructive commands like `git push --force` or hard resets
- If there are no staged files and no unstaged changes, write a warning message to the user and do nothing
