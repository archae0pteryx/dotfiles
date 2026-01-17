# Context priming for code projects

- Use any agent at your disposal to do a comprehensive review of the current project
- If the serena MCP plugin is avail, use this to map the codebase effectively.
- Systematically review the project structure using git.
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