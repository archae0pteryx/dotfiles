---
name: EyePop Git
description: Rules for creating commits and PR in eyepop repos
---

Commits should be in the format of [DOMAIN]: DESCRIPTION. Example: [VLM Worker]: Update config object to support XYZ
PR's should use the same format of [DOMAIN]: Description generally, however, some tasks have associated Jira tickets with them. Always ask if there is a Jira ticket number and if so that should be the [DOMAIN]. Example: [VREE-77]: Some ticket in jira.
Git branches should follow the standard <feat|chore|fix|spike|hotfix|skunkworks>/<description> pattern: Example: feat/support-custom-auth-claim