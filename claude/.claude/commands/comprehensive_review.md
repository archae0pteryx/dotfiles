# Comprehensive code review

Use any and all agents at your disposal to do a systematic review of the current code. Provide a comprehensive list of issues ranked from critical to low using the following guidelines:

- Identify the current scope of work using git and any other tool at your disposal.
- Systematically identify code duplication. Follow symbols to uncover anit-patterns.
- Systematically review external library / api usage. Use Context7 to provide a detailed analysis of mis-used libraries or non industry standard usage
- Identify dead code.
- Confirm all checks pass. This is generally done using `task check`.
- Ask clarifying questions about the current code. The current objective should be very clear and if not, needs to be.

Your summary should have a list of issues and one or two ideas / solutions for fixing them. Some issues are cut and dry and have a clear solution but for others where several options might exist, give a one or two sentence list of options.

Output <promise>COMPREHENSIVE_REVIEW_DONE</promise> when done on a single line