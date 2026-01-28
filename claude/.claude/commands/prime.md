# Context priming for code projects

Utilizing serena and context7 if available, use the following principles to prime your context in an effective manner. Use any agents at your disposal.

- Use any agent at your disposal, review agents or otherwise perform a comprehensive review of the current project.
- If the serena MCP plugin is avail, use this to map the codebase effectively.
- Systematically review the project structure using git ls-files. For each concrete module, identify the core patterns and purposes.
- Understand that comments get stale. Always double check information you read in comments and readmes.
- Identify key patterns.
- Identify the entrypoints of the project.
- Review test files for a deeper understanding.
- Identify any project scripts, look for Taskfiles, Makefile, and a ./scripts/ dir.
- Identify other services that might be related to the microservice ecosystem (if applicable). Where is the code for these related systems, what are any key elements to consider?

Provide a concise summary with the following information:
- What are the core test / checks script(s)
- What are thee entrypoints
- What are the core patterns used if any
- What are the core libraries?
- What is the current developement context if any - what is the implied work being done.

Output <promise>PRIME_DONE</promise> when done on a single line
