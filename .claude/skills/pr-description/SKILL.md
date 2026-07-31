---
name: pr-description
description: Writes short, conversational PR descriptions for this repo instead of the generic Summary/Test-plan-checklist template. Use whenever creating a pull request in this repo, or when asked to write or draft a PR description.
---

# PR description style for this repo

Keep it SHORT. Don't enumerate every file changed or list every method touched — read the diff to understand what happened, but the reader wants the "why", not a change log. No `## Summary` / `## Changes` headers, no bullet-point test-plan checklists. Plain prose, first person, conversational — this is a note to a teammate, not release notes.

## Pick a shape based on the PR

**Small, single-purpose PR** — one or two sentences on what was added, then a `Test plan:` line with one concrete plain-English instruction.

> This PR adds new button for sending the generated media as a separate message.
> Test plan: generate any media (image/video/audio) and try "Send as a separate message" button

**Bug fix** — walk the root cause as a `Problem: ... Why? ... Why?` chain, the way you'd explain it out loud, ending with what the fix does. No bullet list of changes.

> Problem: When user clicks on generate video button, there is a 500 error. Why? Because what happens after the button click takes too long. Why? Because if it's admin, sometimes we wait for chatgpt response to create the video_prompt, then we save it, then we create a record, then we make a request to Fal. While this long part is being executed, telegram button continues waiting and spinning. That's why we need to add SendAnswerCallbackQuery, stopping telegram from waiting.

**Larger/architectural PR** — plain prose explaining what changed and why, first person ("I decided...", "I found..."), explicitly naming any scope-limiting decisions or deferred follow-up work. End with a short test instruction, not a checklist.

> This PR renames Scripts table to Scenes and then adds Scripts table which has many scenes.
> Also, it does a lot of refactoring of existing code. The thing is, I now have too many similar admin commands which are not intuitively clear. For example, cartoon, complex cartoon, script_generation etc.
> So I decided to expose the subject behind these command and now it's either cats_script or bloomy_script etc.
> Mainly the code stays the same but it moved to other subfolders. I also found some classes that are not used anymore and deleted them.
> Also, it introduces new complex cartoon workflow, which I will refactor in next PRs because this one is already huge.
> To test it, please test all the admin commands for regression.

## Rules

- Don't restate what's obvious from the diff (renamed files, moved code) unless it matters to the "why".
- It's fine to explicitly say what's deliberately left out or deferred to a follow-up PR.
- Skip a rule/example that doesn't fit rather than forcing it — pick whichever of the three shapes above is the closest match, or blend them for a PR that's both a fix and a refactor.

## Process

1. Review the diff/commits (`git diff [base]...HEAD`, `git log`) to understand the actual change, same as the repo's standard PR flow.
2. Decide which shape above fits the PR's size and nature, and draft the description in that style.
3. Check whether a PR already exists for the current branch: `gh pr view --json number,url 2>/dev/null`.
4. **PR exists** — update it in place: `gh pr edit --body "<description>"`. Don't touch the title unless asked.
   **No PR exists** — push the branch if it isn't up to date with the remote, then `gh pr create --title "<title>" --body "<description>"`.
5. Do this without pausing for confirmation first — draft and apply in the same pass, then report the PR URL and a one-line summary of what was done (created vs. updated).
