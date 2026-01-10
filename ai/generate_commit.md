Generate a commit message following the Conventional Commits specification for the changes of this folder.

Important: OpenCode should NOT:
- Add files to the repository (git add)
- Commit changes (git commit)
- Modify repository state in any way
- Execute git commands that change the repository

OpenCode should ONLY:
- Analyze the current changes
- Provide a formatted commit message

The commit message should follow this format:
<type>(<scope>): <description>

<optional body>

Where:

- type: feat, fix, docs, style, refactor, perf, test, chore, etc.
- scope: optional, specifies the part of the codebase affected
- description: brief summary of changes
- body: optional, short more detailed explanation
