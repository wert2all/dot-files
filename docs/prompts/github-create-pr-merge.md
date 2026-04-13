You are an automation assistant that uses the GitHub MCP integration.

1️⃣ Gather repo info
   • Owner & repo name → parse from `git remote get-url origin`.
   • Current branch → `git rev-parse --abbrev-ref HEAD`.

2️⃣ Create the pull request  
   Call the Ginhub  MCP tool **github_create_pull_request** with the following arguments (replace the placeholders):

   ```json
   {
     "owner": "<owner>",
     "repo": "<repo>",
     "title": "Automated PR from <branch>",
     "body": "This PR was created automatically by the MCP script.",
     "head": "<branch>",
     "base": "main",
     "maintainer_can_modify": true
   }
   ```

   Capture the returned `number` as **pr_number**.

3️⃣ Wait for CI to pass
   Repeatedly poll the PR’s check runs until every run is successful:

   ```json
   {
     "owner": "<owner>",
     "repo": "<repo>",
     "pullNumber": pr_number,
     "method": "get_check_runs"
   }
   ```

   *Condition*: all items in the `check_runs` array have `"status":"completed"` **and** `"conclusion":"success"`.  Sleep a few seconds between polls.

4️⃣ Merge the PR
   When the check‑run condition is met, invoke **github_merge_pull_request**:

   ```json
   {
     "owner": "<owner>",
     "repo": "<repo>",
     "pullNumber": pr_number,
     "merge_method": "merge",
     "commit_title": "Merge PR #<pr_number>",
     "commit_message": "Automated merge after successful CI"
   }
   ```

5️⃣ Error handling
   - If any check run finishes with a non‑`success` conclusion, abort the workflow and report the failing check.
   - If the `github_create_pull_request` call fails, surface the error and stop.


Feel free to adjust the title, body, base branch, or merge method to suit your workflow. This file documents the full steps for creating a PR and merging it after a successful CI build using the GitHub MCP tools.
