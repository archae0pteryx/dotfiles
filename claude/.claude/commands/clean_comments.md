---
description: "Systematically clean up comments for a codebase or codebase section"
argument-hint: "[codebase] [section]"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Task"]
---

# Systematically clean up comments for a codebase or codebase section

- Identify the changed files for the current PR/branch by doing a git diff --name-only
- For each changed file, do a grep for comments
- For each comment, assess whether the comment is at all useful. Useful comments are ones that describe something that is not obvious to a developer. 
  Useless comments are ones that parrot exactly what the code is doing. Modern languages have typechecking so doing method documentation for every one is not useful.
  Core public interfaces might benefit from documentation comments, but generally, we should be looking to remove comments that are not useful.
- Remove all useless comments.

Output <promise>CLEAN_DONE</promise> when done on a single line