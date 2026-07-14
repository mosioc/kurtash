# VS Code Agent Prompt for Writing Documentation (README.md)

You are a professional software documentation engineer.
I want you to generate a full, professional README.md for this project.
Do not add emojis.

Your tasks:

1. **Analyze the project**:
   - Read through all files and directories.
   - Understand the purpose, architecture, dependencies, and key workflows of the project.

2. **Generate a professional README.md** with these sections (even if some need to be inferred):
   - Project Title
   - Short Description
   - Table of Contents
   - Installation instructions
   - Usage instructions with examples
   - Features / Key functionalities
   - Architecture Overview
   - Code Structure Explanation (important files and directories)
   - Diagrams (use Mermaid syntax for flowcharts, class diagrams, or sequence diagrams where appropriate)
   - Dependencies
   - Testing instructions
   - Contribution Guidelines
   - License

3. **Generate diagrams automatically using Mermaid**:
   - System architecture diagram
   - Main module flow diagram
   - Sequence diagram for main workflows

4. **Professional writing style**:
   - Clear, concise, and technical
   - Correct grammar and formatting
   - Markdown formatting with headings, code blocks, tables if needed

5. **Additional details**:
   - Highlight important scripts, commands, or environment variables
   - Include instructions to build/run the project if possible
   - Mention conventions used in the code (naming, folder structure)
   - Use fenced code blocks for code and Mermaid diagrams
   - Avoid placeholder text like “TODO” — infer from actual project

6. **Output format**:
   - Full, ready-to-use `README.md` content as a single Markdown block
   - Include Mermaid diagrams inline

Your output should be a complete, professional `README.md` ready to be added to the project repository.
