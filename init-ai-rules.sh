#!/bin/bash

# 🚀 AI Rules Initializer - Distribuye workflow en cualquier proyecto
# Soporta: Cursor, Claude Code
# 
# Uso local:
#   ./init-ai-rules.sh <herramienta>
#   
# Uso remoto:
#   curl -s https://raw.githubusercontent.com/jluisflo/ai-dev-tasks/refs/heads/main/init-ai-rules.sh | bash -s <herramienta>
#
# Herramientas: cursor, claude

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Validar herramienta AI proporcionada
validate_ai_tool() {
    local tool="$1"
    local valid_tools=("cursor" "claude")
    
    # Convertir a minúsculas para comparación
    tool=$(echo "$tool" | tr '[:upper:]' '[:lower:]')
    
    # Verificar si la herramienta está en la lista de herramientas válidas
    for valid_tool in "${valid_tools[@]}"; do
        if [ "$tool" = "$valid_tool" ]; then
            echo "$tool"
            return 0
        fi
    done
    
    echo "unknown"
    return 1
}

# Mostrar ayuda del script
show_help() {
    echo -e "${BLUE}🚀 AI Rules Initializer${NC}"
    echo ""
    echo "Configura workflow de desarrollo con IA para diferentes herramientas."
    echo ""
    echo -e "${YELLOW}Uso:${NC}"
    echo "  $0 <herramienta>"
    echo ""
    echo -e "${YELLOW}Herramientas soportadas:${NC}"
    echo "  cursor     - Cursor Editor"
    echo "  claude     - Claude Code"
    echo ""
    echo -e "${YELLOW}Ejemplos:${NC}"
    echo "  $0 cursor"
    echo "  $0 claude"
    echo ""
    echo -e "${YELLOW}Uso remoto:${NC}"
    echo "  curl -s https://raw.githubusercontent.com/jluisflo/ai-dev-tasks/refs/heads/main/init-ai-rules.sh | bash -s cursor"
}

# Crear reglas para Cursor
setup_cursor() {
    echo -e "${BLUE}📁 Configurando para Cursor...${NC}"
    
    mkdir -p .cursor/rules
    
    # create-prd.mdc
    cat > .cursor/rules/create-prd.mdc << 'EOF'
# Rule: Generating a Product Requirements Document (PRD)

## Goal

To guide an AI assistant in creating a detailed Product Requirements Document (PRD) in Markdown format, based on an initial user prompt. The PRD should be clear, actionable, and suitable for a junior developer to understand and implement the feature.

## Process

1.  **Receive Initial Prompt:** The user provides a brief description or request for a new feature or functionality.
2.  **Ask Clarifying Questions:** Before writing the PRD, the AI *must* ask clarifying questions to gather sufficient detail. The goal is to understand the "what" and "why" of the feature, not necessarily the "how" (which the developer will figure out). Make sure to provide options in letter/number lists so I can respond easily with my selections.
3.  **Generate PRD:** Based on the initial prompt and the user's answers to the clarifying questions, generate a PRD using the structure outlined below.
4.  **Save PRD:** Save the generated document as `prd-[feature-name].md` inside the `/tasks` directory.

## Clarifying Questions (Examples)

The AI should adapt its questions based on the prompt, but here are some common areas to explore:

*   **Problem/Goal:** "What problem does this feature solve for the user?" or "What is the main goal we want to achieve with this feature?"
*   **Target User:** "Who is the primary user of this feature?"
*   **Core Functionality:** "Can you describe the key actions a user should be able to perform with this feature?"
*   **User Stories:** "Could you provide a few user stories? (e.g., As a [type of user], I want to [perform an action] so that [benefit].)"
*   **Acceptance Criteria:** "How will we know when this feature is successfully implemented? What are the key success criteria?"
*   **Scope/Boundaries:** "Are there any specific things this feature *should not* do (non-goals)?"
*   **Data Requirements:** "What kind of data does this feature need to display or manipulate?"
*   **Design/UI:** "Are there any existing design mockups or UI guidelines to follow?" or "Can you describe the desired look and feel?"
*   **Edge Cases:** "Are there any potential edge cases or error conditions we should consider?"

## PRD Structure

The generated PRD should include the following sections:

1.  **Introduction/Overview:** Briefly describe the feature and the problem it solves. State the goal.
2.  **Goals:** List the specific, measurable objectives for this feature.
3.  **User Stories:** Detail the user narratives describing feature usage and benefits.
4.  **Functional Requirements:** List the specific functionalities the feature must have. Use clear, concise language (e.g., "The system must allow users to upload a profile picture."). Number these requirements.
5.  **Non-Goals (Out of Scope):** Clearly state what this feature will *not* include to manage scope.
6.  **Design Considerations (Optional):** Link to mockups, describe UI/UX requirements, or mention relevant components/styles if applicable.
7.  **Technical Considerations (Optional):** Mention any known technical constraints, dependencies, or suggestions (e.g., "Should integrate with the existing Auth module").
8.  **Success Metrics:** How will the success of this feature be measured? (e.g., "Increase user engagement by 10%", "Reduce support tickets related to X").
9.  **Open Questions:** List any remaining questions or areas needing further clarification.

## Target Audience

Assume the primary reader of the PRD is a **junior developer**. Therefore, requirements should be explicit, unambiguous, and avoid jargon where possible. Provide enough detail for them to understand the feature's purpose and core logic.

## Output

*   **Format:** Markdown (`.md`)
*   **Location:** `/tasks/`
*   **Filename:** `prd-[feature-name].md`

## Final instructions

1. Do NOT start implementing the PRD
2. Make sure to ask the user clarifying questions
3. Take the user's answers to the clarifying questions and improve the PRD
EOF

    # generate-tasks.mdc
    cat > .cursor/rules/generate-tasks.mdc << 'EOF'
# Rule: Generating a Task List from a PRD

## Goal

To guide an AI assistant in creating a detailed, step-by-step task list in Markdown format based on an existing Product Requirements Document (PRD). The task list should guide a developer through implementation.

## Output

- **Format:** Markdown (`.md`)
- **Location:** `/tasks/`
- **Filename:** `tasks-[prd-file-name].md` (e.g., `tasks-prd-user-profile-editing.md`)

## Process

1.  **Receive PRD Reference:** The user points the AI to a specific PRD file
2.  **Analyze PRD:** The AI reads and analyzes the functional requirements, user stories, and other sections of the specified PRD.
3.  **Phase 1: Generate Parent Tasks:** Based on the PRD analysis, create the file and generate the main, high-level tasks required to implement the feature. Use your judgement on how many high-level tasks to use. It's likely to be about 5. Present these tasks to the user in the specified format (without sub-tasks yet). Inform the user: "I have generated the high-level tasks based on the PRD. Ready to generate the sub-tasks? Respond with 'Go' to proceed."
4.  **Wait for Confirmation:** Pause and wait for the user to respond with "Go".
5.  **Phase 2: Generate Sub-Tasks:** Once the user confirms, break down each parent task into smaller, actionable sub-tasks necessary to complete the parent task. Ensure sub-tasks logically follow from the parent task and cover the implementation details implied by the PRD.
6.  **Identify Relevant Files:** Based on the tasks and PRD, identify potential files that will need to be created or modified. List these under the `Relevant Files` section, including corresponding test files if applicable.
7.  **Generate Final Output:** Combine the parent tasks, sub-tasks, relevant files, and notes into the final Markdown structure.
8.  **Save Task List:** Save the generated document in the `/tasks/` directory with the filename `tasks-[prd-file-name].md`, where `[prd-file-name]` matches the base name of the input PRD file (e.g., if the input was `prd-user-profile-editing.md`, the output is `tasks-prd-user-profile-editing.md`).

## Output Format

The generated task list _must_ follow this structure:

```markdown
## Relevant Files

- `path/to/potential/file1.ts` - Brief description of why this file is relevant (e.g., Contains the main component for this feature).
- `path/to/file1.test.ts` - Unit tests for `file1.ts`.
- `path/to/another/file.tsx` - Brief description (e.g., API route handler for data submission).
- `path/to/another/file.test.tsx` - Unit tests for `another/file.tsx`.
- `lib/utils/helpers.ts` - Brief description (e.g., Utility functions needed for calculations).
- `lib/utils/helpers.test.ts` - Unit tests for `helpers.ts`.

### Notes

- Unit tests should typically be placed alongside the code files they are testing (e.g., `MyComponent.tsx` and `MyComponent.test.tsx` in the same directory).
- Use `npx jest [optional/path/to/test/file]` to run tests. Running without a path executes all tests found by the Jest configuration.

## Tasks

- [ ] 1.0 Parent Task Title
  - [ ] 1.1 [Sub-task description 1.1]
  - [ ] 1.2 [Sub-task description 1.2]
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 [Sub-task description 2.1]
- [ ] 3.0 Parent Task Title (may not require sub-tasks if purely structural or configuration)
```

## Interaction Model

The process explicitly requires a pause after generating parent tasks to get user confirmation ("Go") before proceeding to generate the detailed sub-tasks. This ensures the high-level plan aligns with user expectations before diving into details.

## Target Audience

Assume the primary reader of the task list is a **junior developer** who will implement the feature.
EOF

    # process-task-list.mdc
    cat > .cursor/rules/process-task-list.mdc << 'EOF'
# Task List Management

Guidelines for managing task lists in markdown files to track progress on completing a PRD

## Task Implementation
- **One sub-task at a time:** Do **NOT** start the next sub‑task until you ask the user for permission and they say "yes" or "y"
- **Completion protocol:**  
  1. When you finish a **sub‑task**, immediately mark it as completed by changing `[ ]` to `[x]`.
  2. If **all** subtasks underneath a parent task are now `[x]`, follow this sequence:
    - **First**: Run the full test suite (`pytest`, `npm test`, `bin/rails test`, etc.)
    - **Only if all tests pass**: Stage changes (`git add .`)
    - **Clean up**: Remove any temporary files and temporary code before committing
    - **Commit**: Use a descriptive commit message that:
      - Uses conventional commit format (`feat:`, `fix:`, `refactor:`, etc.)
      - Summarizes what was accomplished in the parent task
      - Lists key changes and additions
      - References the task number and PRD context
      - **Formats the message as a single-line command using `-m` flags**, e.g.:

        ```
        git commit -m "feat: add payment validation logic" -m "- Validates card type and expiry" -m "- Adds unit tests for edge cases" -m "Related to T123 in PRD"
        ```
  3. Once all the subtasks are marked completed and changes have been committed, mark the **parent task** as completed.
- Stop after each sub‑task and wait for the user's go‑ahead.

## Task List Maintenance

1. **Update the task list as you work:**
   - Mark tasks and subtasks as completed (`[x]`) per the protocol above.
   - Add new tasks as they emerge.

2. **Maintain the "Relevant Files" section:**
   - List every file created or modified.
   - Give each file a one‑line description of its purpose.

## AI Instructions

When working with task lists, the AI must:

1. Regularly update the task list file after finishing any significant work.
2. Follow the completion protocol:
   - Mark each finished **sub‑task** `[x]`.
   - Mark the **parent task** `[x]` once **all** its subtasks are `[x]`.
3. Add newly discovered tasks.
4. Keep "Relevant Files" accurate and up to date.
5. Before starting work, check which sub‑task is next.
6. After implementing a sub‑task, update the file and then pause for user approval.
EOF

    echo -e "${GREEN}✅ Reglas de Cursor configuradas${NC}"
}







# Crear reglas para Claude Code
setup_claude() {
    echo -e "${BLUE}🤖 Configurando para Claude Code...${NC}"
    
    # Crear directorio para Claude si no existe
    mkdir -p .claude
    
    # Verificar e instruir sobre gh CLI
    echo -e "${YELLOW}🔍 Verificando GitHub CLI...${NC}"
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}✅ GitHub CLI encontrado${NC}"
    else
        echo -e "${YELLOW}⚠️ GitHub CLI no encontrado. Para mejor integración con GitHub:${NC}"
        echo "   - macOS: brew install gh"
        echo "   - Ubuntu: sudo apt install gh"
        echo "   - Windows: winget install GitHub.cli"
        echo "   Después ejecuta: gh auth login"
    fi
    
    # Crear archivo de configuración principal para Claude
    cat > CLAUDE.md << 'EOF'
# Claude AI Development Workflow

## IMPORTANT System Instructions

You are an expert software developer following a structured, task-oriented development workflow. Your primary goal is to implement features systematically while maintaining high code quality and following existing project patterns.

**YOU MUST** always follow the quality standards and communication protocols defined below.

## Bash Commands
Common commands available in this project:
- `npm run build` / `yarn build` / `pnpm build`: Build the project
- `npm test` / `yarn test` / `pnpm test`: Run tests
- `npm run lint` / `yarn lint` / `pnpm lint`: Run linter
- `npm run typecheck` / `yarn typecheck`: Run TypeScript type checking
- `git status`: Check git status
- `git add .`: Stage changes
- `git commit -m "message"`: Commit changes
- `gh issue list`: List GitHub issues (if gh CLI available)
- `gh pr create`: Create pull request

## Code Style Guidelines
- Follow existing code patterns and architecture
- Use consistent naming conventions
- Implement proper error handling for all functions
- Add TypeScript types where applicable
- Write self-documenting code with clear variable names
- Add comments for complex business logic only

## Core Workflow

### 1. PRD Creation Mode
When asked to create a PRD (Product Requirement Document):

1. **Analyze Context**: Review the feature request and examine existing codebase
2. **Create Comprehensive PRD** with these sections:
   - Overview (Feature Name, Priority, Effort, Target Release)
   - Problem Statement (Current State, Pain Points, User Impact)
   - Solution Overview (Proposed Solution, Benefits, Success Metrics)
   - Detailed Requirements (Functional, Technical, UI/UX)
   - Implementation Considerations (Dependencies, Risks, Security)
   - Testing Strategy (Unit, Integration, UAT, Performance)
   - Launch Plan (Rollout, Monitoring, Rollback)
   - Documentation Requirements
   - Future Considerations

3. **Save as**: `[feature-name]-PRD.md` in project root or docs folder

### 2. Task Generation Mode
When asked to generate tasks from a PRD:

1. **Analyze the PRD** thoroughly
2. **Create Hierarchical Task Breakdown**:
   - Phase 1: Planning and Setup
   - Phase 2: Backend Development  
   - Phase 3: Frontend Development
   - Phase 4: Testing
   - Phase 5: Documentation and Deployment
   - Post-Launch Tasks

3. **Task Guidelines**:
   - Make tasks specific and actionable
   - Include effort estimates: [Small: 1-4h, Medium: 4-8h, Large: 1-3d]
   - Note dependencies between tasks
   - Add acceptance criteria for complex tasks

4. **Save as**: `tasks-[feature-name].md` in tasks folder

### 3. Task Processing Mode
When asked to process tasks:

1. **Start with first incomplete task** (lowest numbered)
2. **Work on ONE task at a time**
3. **For each task**:
   - Analyze requirements and acceptance criteria
   - Plan implementation approach
   - Implement the solution
   - Verify it meets acceptance criteria
   - Update documentation if needed

4. **After completion**:
   - Mark task as complete: `✅ [Completed: YYYY-MM-DD HH:MM]`
   - Request approval before proceeding to next task
   - Update task list with progress

## Quality Standards

- Follow existing code patterns and architecture
- Implement comprehensive error handling
- Add appropriate logging and monitoring
- Ensure security best practices
- Write maintainable, readable code
- Include proper testing coverage
- Update documentation as needed

## Communication Protocol

- After completing each task: "Task [X.X.X] has been completed. Please review and confirm before I proceed to task [Y.Y.Y]"
- Wait for user confirmation before moving to next task
- If blockers arise, clearly state the issue and suggest alternatives
- Focus on quality over speed

## Branch and Commit Strategy

- Work on designated feature branch
- Make atomic commits for each subtask
- Use descriptive commit messages: `feat: implement task 1.2.3 - add user validation`

## Key Rules

- NEVER skip tasks without explicit approval
- ALWAYS wait for confirmation before proceeding
- MAINTAIN task list with current status
- FOCUS on quality and existing patterns
- COMMUNICATE clearly about progress and issues

## MCP Integration

When using MCP servers, leverage them for:
- Filesystem operations for reading/writing project files
- Database operations for schema and data management
- GitHub integration for repository management
- Web search for technical research and best practices

## Activation Commands

Use these phrases to activate specific workflows:
- "Create PRD for [feature description]" → PRD Creation Mode
- "Generate tasks from PRD" → Task Generation Mode  
- "Process task list" → Task Processing Mode
- "Start implementation" → Begin systematic task execution

## Debug and Iteration
- Use `/clear` frequently to reset context between different tasks
- Use `/undo` to revert changes and try different approaches
- Ask Claude to create checklists for complex multi-step tasks
- Use the `#` key to add instructions to CLAUDE.md during development

IMPORTANT: Always follow the task-based workflow and wait for approval between major changes.
EOF

    # Crear configuración MCP básica si no existe
    if [ ! -f "claude_desktop_config.json" ]; then
        cat > claude_desktop_config.json << 'EOF'
{
  "globalShortcut": "Alt+C",
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": [
        "@modelcontextprotocol/server-filesystem",
        "."
      ]
    }
  }
}
EOF
    fi
    
    # Crear configuración de herramientas permitidas si no existe
    if [ ! -f ".claude/settings.json" ]; then
        cat > .claude/settings.json << 'EOF'
{
  "allowedTools": [
    "Edit",
    "Bash(git add:*)",
    "Bash(git commit:*)",
    "Bash(git push:*)",
    "Bash(git status:*)",
    "Bash(git log:*)",
    "Bash(npm run:*)",
    "Bash(yarn:*)",
    "Bash(pnpm:*)",
    "mcp__filesystem__read_file",
    "mcp__filesystem__write_file",
    "mcp__filesystem__list_directory"
  ]
}
EOF
    fi
    
    # Crear archivo de instrucciones específicas para el proyecto
    cat > .claude/project-instructions.md << 'EOF'
# Project-Specific Instructions for Claude

## Development Environment
- Follow the existing code style and patterns in this project
- Use the configured linting and formatting rules
- Maintain consistency with existing architecture

## Task Management
- Tasks are stored in the `tasks/` directory
- PRDs are stored in the project root or `docs/` directory
- Always update task status and progress

## Quality Checklist
- [ ] Code follows project patterns
- [ ] All tests pass
- [ ] Documentation updated
- [ ] No linting errors
- [ ] Security considerations addressed
- [ ] Performance implications considered

## Project Context
Update this section with project-specific information:
- Technology stack: [Add your stack here]
- Key architectural decisions: [Add key decisions here]
- Important patterns to follow: [Add patterns here]
- Testing strategy: [Add testing approach here]
EOF

    # Crear directorio para comandos personalizados
    mkdir -p .claude/commands
    
    # Crear comandos slash personalizados según mejores prácticas
    cat > .claude/commands/create-prd.md << 'EOF'
Create a comprehensive Product Requirement Document (PRD) for: $ARGUMENTS

Follow these steps:
1. Analyze the feature request and examine existing codebase patterns
2. Create a detailed PRD with all required sections:
   - Overview (Feature Name, Priority, Effort, Target Release)
   - Problem Statement (Current State, Pain Points, User Impact)  
   - Solution Overview (Proposed Solution, Benefits, Success Metrics)
   - Detailed Requirements (Functional, Technical, UI/UX)
   - Implementation Considerations (Dependencies, Risks, Security)
   - Testing Strategy (Unit, Integration, UAT, Performance)
   - Launch Plan (Rollout, Monitoring, Rollback)
   - Documentation Requirements
   - Future Considerations
3. Save the PRD as `[feature-name]-PRD.md` in the project root
4. Create initial task outline for implementation phases

Remember to reference existing code patterns and architecture decisions.
EOF

    cat > .claude/commands/generate-tasks.md << 'EOF'
Generate a comprehensive task breakdown from the PRD: $ARGUMENTS

Follow these steps:
1. Read and analyze the specified PRD file
2. Create hierarchical task structure with these phases:
   - Phase 1: Planning and Setup
   - Phase 2: Backend Development
   - Phase 3: Frontend Development
   - Phase 4: Testing
   - Phase 5: Documentation and Deployment
   - Post-Launch Tasks
3. Make each task specific and actionable
4. Include effort estimates [Small: 1-4h, Medium: 4-8h, Large: 1-3d]
5. Note dependencies between tasks
6. Add acceptance criteria for complex tasks
7. Save as `tasks-[feature-name].md` in the tasks directory

Ensure tasks align with existing project architecture and patterns.
EOF

    cat > .claude/commands/fix-github-issue.md << 'EOF'
Analyze and fix the GitHub issue: $ARGUMENTS

Follow these steps:
1. Use `gh issue view` to get the issue details
2. Understand the problem described in the issue
3. Search the codebase for relevant files
4. Implement the necessary changes to fix the issue
5. Write and run tests to verify the fix
6. Ensure code passes linting and type checking
7. Create a descriptive commit message
8. Push changes and create a PR if needed

Remember to use the GitHub CLI (`gh`) for all GitHub-related tasks.
EOF

    cat > .claude/commands/code-review.md << 'EOF'
Perform a comprehensive code review of: $ARGUMENTS

Review checklist:
1. **Code Quality**:
   - Follows existing code patterns and style
   - Proper error handling and edge cases
   - No code duplication or unnecessary complexity
   - Clear variable and function names

2. **Security**:
   - Input validation and sanitization
   - No hardcoded secrets or sensitive data
   - Proper authentication and authorization

3. **Performance**:
   - Efficient algorithms and data structures
   - No memory leaks or resource waste
   - Database queries optimized

4. **Testing**:
   - Adequate test coverage
   - Tests cover edge cases
   - Tests are maintainable and readable

5. **Documentation**:
   - Code is self-documenting
   - Complex logic has comments
   - API changes documented

Provide specific feedback with file names and line numbers where applicable.
EOF

    cat > .claude/commands/debug-logs.md << 'EOF'
Analyze and debug the logs: $ARGUMENTS

Debug process:
1. **Parse the logs** to identify patterns and errors
2. **Categorize issues** by severity and frequency
3. **Trace error origins** through stack traces and timestamps
4. **Identify root causes** and potential fixes
5. **Suggest monitoring improvements** to prevent similar issues
6. **Create action items** with priority levels

Focus on:
- Error patterns and frequency
- Performance bottlenecks
- Security concerns
- User impact assessment

Provide specific recommendations for fixes and improvements.
EOF

    # Crear script de ayuda para comandos comunes
    cat > .claude/workflow-commands.md << 'EOF'
# Claude Workflow Commands

## Custom Slash Commands

The following custom commands are available (use with `/project:`):

### `/project:create-prd [feature description]`
Creates a comprehensive PRD for the specified feature

### `/project:generate-tasks [feature-name]`
Generates hierarchical task breakdown from an existing PRD

### `/project:fix-github-issue [issue-number]`
Analyzes and fixes a GitHub issue using gh CLI

### `/project:code-review [file/directory]`
Performs comprehensive code review with security, performance, and quality checks

### `/project:debug-logs [log-file-or-data]`
Analyzes logs to identify patterns, errors, and root causes

## Quick Start Commands

### PRD Creation
```
/project:create-prd user authentication system
```

### Task Generation  
```
/project:generate-tasks user-auth
```

### GitHub Integration
```
/project:fix-github-issue 123
```

### Code Review
```
/project:code-review src/auth/
```

## File Operations
- Use MCP filesystem server to read/write files
- Always maintain task list updates
- Save PRDs and task lists in appropriate locations

## Best Practices
- Work systematically through tasks
- Request approval between major tasks
- Focus on one task at a time
- Maintain high code quality
- Use custom slash commands for common workflows
EOF

    # Crear documentación de mejores prácticas esenciales
    cat > .claude/best-practices.md << 'EOF'
# Claude Code Best Practices

## Setup Configuration

### Allowed Tools 
Pre-configured safe tools in `.claude/settings.json`:
- File editing operations
- Common git commands  
- Package manager commands (npm, yarn, pnpm)
- MCP filesystem operations

Add more tools using `/permissions` command or editing the settings file.

### GitHub Integration
If `gh` CLI is available, Claude can:
- Create and manage issues
- Open pull requests
- Read repository information

Install with: `brew install gh` (macOS) or `sudo apt install gh` (Ubuntu)

## Workflow Tips

### Context Management
- Use `/clear` between different tasks to reset context
- Keep `CLAUDE.md` focused on your workflow
- Use `#` key to add project-specific instructions

### Task Management
For complex features, use checklists:
```markdown
# Feature Checklist
- [ ] Create PRD
- [ ] Generate task list
- [ ] Implement tasks one by one
- [ ] Test and review
```

## Custom Commands Available

### Development
- `/project:create-prd [feature]` - Create PRD
- `/project:generate-tasks [feature]` - Generate task list
- `/project:code-review [path]` - Review code
- `/project:fix-github-issue [number]` - Fix GitHub issue
- `/project:debug-logs [data]` - Analyze logs

### Core Commands
- `/clear` - Reset context
- `/undo` - Revert last change
- `/permissions` - Manage tool permissions

## Tips for Better Results

1. **Be Specific**: Clear instructions get better results
2. **Provide Context**: Include relevant files and error messages
3. **Follow Workflow**: PRD → Tasks → Implementation
4. **Quality Gates**: Test after each major change

Remember: Follow the structured workflow for best results.
EOF

    echo -e "${GREEN}✅ Reglas de Claude Code configuradas${NC}"
    echo -e "${GREEN}📁 Archivos creados:${NC}"
    echo "   - CLAUDE.md (instrucciones principales)"
    echo "   - claude_desktop_config.json (configuración MCP básica)"
    echo "   - .claude/settings.json (herramientas permitidas)"
    echo "   - .claude/commands/ (5 comandos slash personalizados)"
    echo "   - .claude/best-practices.md (guía esencial)"
}



# Script principal
main() {
    local provided_tool="$1"
    
    # Verificar si se proporcionó un parámetro
    if [ -z "$provided_tool" ]; then
        echo -e "${YELLOW}❌ Error: Debes especificar una herramienta AI${NC}"
        echo ""
        show_help
        exit 1
    fi
    
    # Validar herramienta proporcionada
    TOOL=$(validate_ai_tool "$provided_tool")
    if [ "$TOOL" = "unknown" ]; then
        echo -e "${YELLOW}❌ Error: Herramienta '$provided_tool' no soportada${NC}"
        echo ""
        show_help
        exit 1
    fi
    
    echo -e "${BLUE}"
    echo "🚀 AI Rules Initializer"
    echo "Configurando workflow de desarrollo con IA..."
    echo -e "${NC}"
    
    echo -e "${YELLOW}🔧 Configurando para: $TOOL${NC}"
    
    # Configurar según herramienta
    case $TOOL in
        "cursor")
            setup_cursor
            ;;
        "claude")
            setup_claude
            ;;
    esac
    
    # Crear carpeta de tareas si no existe
    mkdir -p tasks
    
    echo -e "${GREEN}"
    echo "🎉 ¡Configuración completada!"
    echo ""
    echo "📁 Archivos creados para: $TOOL"
    echo "📋 Carpeta 'tasks' lista para tus implementaciones"
    echo ""
    echo "🔄 Próximos pasos:"
    if [ "$TOOL" = "claude" ]; then
        echo "1. 🚀 Reinicia Claude Desktop para cargar las nuevas reglas"
        echo "2. 📖 Revisa CLAUDE.md y .claude/best-practices.md"
        echo "3. 🛠️  Instala gh CLI para integración con GitHub (si no lo tienes)"
        echo ""
        echo "💡 Comandos disponibles:"
        echo "   • /project:create-prd [feature] - Crear PRD"
        echo "   • /project:generate-tasks [feature] - Generar tareas"
        echo "   • /project:fix-github-issue [número] - Arreglar issue"
        echo "   • /project:code-review [path] - Revisar código"
        echo "   • /project:debug-logs [data] - Analizar logs"
        echo ""
        echo "🎯 Setup esencial para nuestro workflow PRD → Tasks → Processing"
    else
        echo "1. Reinicia Cursor para cargar las nuevas reglas"
        echo "2. Usa: @create-prd [descripción del feature]"
        echo "3. Luego: @generate-tasks [nombre-del-prd]"
        echo "4. Finalmente: @process-task-list [nombre-de-tasks]"
    fi
    echo -e "${NC}"
}

# Ejecutar si se llama directamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 