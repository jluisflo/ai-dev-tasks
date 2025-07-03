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

You are an expert software developer following the EXACT same structured workflow as the Cursor .mdc files. Your primary goal is to implement features systematically using the interactive 3-step process.

**YOU MUST** follow the same workflow patterns as create-prd.mdc, generate-tasks.mdc, and process-task-list.mdc.

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

## Core Workflow (Same as Cursor .mdc files)

### 1. PRD Creation Mode (Interactive)
When asked to create a PRD (Product Requirement Document):

**PROCESS:**
1. **Receive Initial Prompt:** User provides brief description of feature
2. **Ask Clarifying Questions:** BEFORE writing PRD, ask clarifying questions to gather detail. Provide options in numbered lists for easy selection.
3. **Generate PRD:** Based on answers, create PRD with proper structure
4. **Save PRD:** Save as `prd-[feature-name].md` in `/tasks/` directory

**CLARIFYING QUESTIONS (Examples):**
- Problem/Goal: "What problem does this feature solve?"
- Target User: "Who is the primary user?"
- Core Functionality: "Key actions users should perform?"
- User Stories: "Provide user stories (As a [user], I want [action] so [benefit])"
- Acceptance Criteria: "Success criteria?"
- Scope/Boundaries: "What should this NOT do?"
- Data Requirements: "What data needed?"
- Design/UI: "Any design guidelines or mockups?"
- Edge Cases: "Potential edge cases to consider?"

**PRD STRUCTURE:**
1. Introduction/Overview
2. Goals
3. User Stories
4. Functional Requirements (numbered)
5. Non-Goals (Out of Scope)
6. Design Considerations (Optional)
7. Technical Considerations (Optional)
8. Success Metrics
9. Open Questions

**Target Audience:** Junior developer

### 2. Task Generation Mode (2-Phase Process)
When asked to generate tasks from a PRD:

**PROCESS:**
1. **Receive PRD Reference:** User points to specific PRD file
2. **Analyze PRD:** Read functional requirements, user stories, etc.
3. **Phase 1: Generate Parent Tasks:** Create ~5 high-level tasks. Present WITHOUT subtasks yet. Say: "I have generated the high-level tasks based on the PRD. Ready to generate the sub-tasks? Respond with 'Go' to proceed."
4. **Wait for Confirmation:** Pause for user to respond "Go"
5. **Phase 2: Generate Sub-Tasks:** Break down each parent into actionable sub-tasks
6. **Identify Relevant Files:** List files to create/modify with test files
7. **Save Task List:** Save as `tasks-[prd-file-name].md` in `/tasks/`

**OUTPUT FORMAT:**
```markdown
## Relevant Files
- `path/file.ts` - Description
- `path/file.test.ts` - Unit tests

### Notes
- Unit tests alongside code files
- Use `npx jest [path]` to run tests

## Tasks
- [ ] 1.0 Parent Task Title
  - [ ] 1.1 Sub-task description
  - [ ] 1.2 Sub-task description
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 Sub-task description
```

### 3. Task Processing Mode (One Sub-task at a Time)
When asked to process tasks:

**TASK IMPLEMENTATION:**
- **One sub-task at a time:** Do NOT start next until user says "yes" or "y"
- **Completion Protocol:**
  1. Finish sub-task → mark `[x]`
  2. If ALL subtasks under parent are `[x]`:
     - Run full test suite
     - Only if tests pass: `git add .`
     - Clean up temporary files
     - Commit with conventional format:
       ```
       git commit -m "feat: parent task summary" -m "- Key changes" -m "- Unit tests added" -m "Related to PRD"
       ```
  3. Mark parent task `[x]`
- Stop after each sub-task for user approval

**TASK LIST MAINTENANCE:**
1. Update task list as you work
2. Mark completed sub-tasks `[x]`
3. Add new tasks as discovered
4. Keep "Relevant Files" updated

**AI INSTRUCTIONS:**
1. Update task list file after significant work
2. Follow completion protocol exactly
3. Add newly discovered tasks
4. Keep files accurate
5. Check which sub-task is next
6. Pause for approval after each sub-task

## Quality Standards
- Follow existing code patterns and architecture
- Implement proper error handling
- Add TypeScript types where applicable
- Write self-documenting code
- Test coverage for all new code
- Update documentation as needed

## File Naming Conventions
- PRDs: `prd-[feature-name].md`
- Tasks: `tasks-prd-[feature-name].md`
- Location: `/tasks/` directory

## Key Rules (Same as Cursor)
- NEVER skip the interactive questioning for PRDs
- ALWAYS wait for "Go" confirmation in task generation
- NEVER start next sub-task without "yes"/"y" approval
- MAINTAIN consistent file naming
- FOCUS on quality over speed

IMPORTANT: This workflow mirrors exactly what Cursor does with .mdc files. Stay consistent!
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
Create a Product Requirement Document (PRD) for: $ARGUMENTS

**INTERACTIVE PROCESS (Same as create-prd.mdc):**

1. **Receive Initial Prompt:** Feature description: $ARGUMENTS

2. **Ask Clarifying Questions FIRST:** Before writing PRD, ask clarifying questions with numbered options for easy selection:
   - Problem/Goal: "What problem does this feature solve for the user?"
   - Target User: "Who is the primary user of this feature?"
   - Core Functionality: "Key actions a user should be able to perform?"
   - User Stories: "Provide user stories (As a [user], I want [action] so that [benefit])"
   - Acceptance Criteria: "How will we know when successfully implemented?"
   - Scope/Boundaries: "What should this feature NOT do (non-goals)?"
   - Data Requirements: "What data does this feature need?"
   - Design/UI: "Any existing design mockups or UI guidelines?"
   - Edge Cases: "Potential edge cases or error conditions?"

3. **Generate PRD:** Based on user answers, create PRD with structure:
   - Introduction/Overview
   - Goals  
   - User Stories
   - Functional Requirements (numbered)
   - Non-Goals (Out of Scope)
   - Design Considerations (Optional)
   - Technical Considerations (Optional)
   - Success Metrics
   - Open Questions

4. **Save PRD:** Save as `prd-[feature-name].md` in `/tasks/` directory

**Target Audience:** Junior developer - use clear, unambiguous language.

IMPORTANT: Do NOT start implementing. Make sure to ask clarifying questions first.
EOF

    cat > .claude/commands/generate-tasks.md << 'EOF'
Generate task breakdown from PRD: $ARGUMENTS

**2-PHASE PROCESS (Same as generate-tasks.mdc):**

1. **Receive PRD Reference:** User points to PRD: $ARGUMENTS

2. **Analyze PRD:** Read and analyze functional requirements, user stories, and other sections.

3. **Phase 1: Generate Parent Tasks:** 
   - Create the file and generate ~5 main, high-level tasks
   - Present WITHOUT sub-tasks yet
   - Say: "I have generated the high-level tasks based on the PRD. Ready to generate the sub-tasks? Respond with 'Go' to proceed."

4. **Wait for Confirmation:** Pause and wait for user to respond with "Go"

5. **Phase 2: Generate Sub-Tasks:** 
   - Break down each parent task into actionable sub-tasks
   - Ensure sub-tasks logically follow from parent task

6. **Identify Relevant Files:** List files to create/modify with test files

7. **Save Task List:** Save as `tasks-[prd-file-name].md` in `/tasks/` directory

**OUTPUT FORMAT:**
```markdown
## Relevant Files
- `path/file.ts` - Description
- `path/file.test.ts` - Unit tests

### Notes
- Unit tests alongside code files  
- Use `npx jest [path]` to run tests

## Tasks
- [ ] 1.0 Parent Task Title
  - [ ] 1.1 Sub-task description
  - [ ] 1.2 Sub-task description
- [ ] 2.0 Parent Task Title
  - [ ] 2.1 Sub-task description
```

**Target Audience:** Junior developer

IMPORTANT: Must pause after parent tasks and wait for "Go" confirmation.
EOF

    cat > .claude/commands/process-tasks.md << 'EOF'
Process task list: $ARGUMENTS

**ONE SUB-TASK AT A TIME (Same as process-task-list.mdc):**

**TASK IMPLEMENTATION:**
- **One sub-task at a time:** Do NOT start next sub-task until user says "yes" or "y"
- **Completion Protocol:**
  1. Finish sub-task → mark `[x]`
  2. If ALL subtasks under parent task are `[x]`:
     - Run full test suite (`npm test`, `pytest`, etc.)
     - Only if tests pass: `git add .`
     - Clean up temporary files
     - Commit with conventional format:
       ```
       git commit -m "feat: parent task summary" -m "- Key changes" -m "- Unit tests added" -m "Related to PRD"
       ```
  3. Mark parent task `[x]`
- Stop after each sub-task for user approval

**TASK LIST MAINTENANCE:**
1. Update task list file as you work
2. Mark completed sub-tasks `[x]`
3. Add new tasks as discovered
4. Keep "Relevant Files" section updated

**AI INSTRUCTIONS:**
1. Check which sub-task is next
2. Implement one sub-task completely
3. Update the task list file
4. Pause for user approval ("yes"/"y")
5. Repeat for next sub-task

IMPORTANT: Follow the exact same protocol as process-task-list.mdc
EOF



    # Crear script de ayuda para comandos comunes
    cat > .claude/workflow-commands.md << 'EOF'
# Claude Workflow Commands

## Core Workflow Commands (Same as Cursor .mdc files)

### `/project:create-prd [feature description]`
**Interactive PRD Creation** - Asks clarifying questions first, then generates PRD
- Example: `/project:create-prd user authentication system`
- Saves as: `prd-[feature-name].md` in `/tasks/`

### `/project:generate-tasks [feature-name]` 
**2-Phase Task Generation** - Parent tasks → "Go" confirmation → Sub-tasks
- Example: `/project:generate-tasks user-auth`
- Saves as: `tasks-prd-[feature-name].md` in `/tasks/`

### `/project:process-tasks [task-file]`
**One Sub-task at a Time** - Implements sub-tasks with "yes"/"y" confirmations
- Example: `/project:process-tasks tasks-prd-user-auth.md`
- Marks `[x]` and commits when parent task complete

## Workflow Steps

1. **Create PRD**: Answer clarifying questions → PRD generated
2. **Generate Tasks**: Parent tasks shown → Respond "Go" → Sub-tasks generated  
3. **Process Tasks**: One sub-task → Respond "yes"/"y" → Next sub-task

## File Naming Convention
- PRDs: `prd-[feature-name].md`
- Tasks: `tasks-prd-[feature-name].md`
- Location: `/tasks/` directory

## Best Practices
- **Answer all clarifying questions** for better PRDs
- **Always respond "Go"** to proceed with sub-task generation
- **Respond "yes"/"y"** after reviewing each completed sub-task
- **One sub-task at a time** - no parallel work
- **Follow the same workflow as Cursor** - stay consistent!

IMPORTANT: This mirrors exactly the Cursor .mdc workflow for consistency.
EOF

    # Crear documentación de mejores prácticas esenciales
    cat > .claude/best-practices.md << 'EOF'
# Claude Code Best Practices - Synchronized with Cursor

## Workflow Consistency
This setup mirrors **exactly** the Cursor .mdc workflow to ensure consistency across AI tools.

## Core Workflow (Same as Cursor)

### 1. Interactive PRD Creation
- **Always answer clarifying questions** thoroughly
- **Use numbered options** when provided for easy selection
- **Don't skip the question phase** - it improves PRD quality
- **Files saved as**: `prd-[feature-name].md` in `/tasks/`

### 2. 2-Phase Task Generation  
- **Phase 1**: Review parent tasks carefully
- **Respond "Go"** when ready for sub-tasks (don't skip this!)
- **Phase 2**: Sub-tasks generated automatically
- **Files saved as**: `tasks-prd-[feature-name].md` in `/tasks/`

### 3. One Sub-task Implementation
- **One sub-task at a time** - no parallel work
- **Respond "yes"/"y"** to proceed to next sub-task
- **Parent task commits** happen automatically when all sub-tasks done
- **Follow marking**: `[ ]` → `[x]` for completed sub-tasks

## Commands Available

### Core Workflow Commands
- `/project:create-prd [feature]` - Interactive PRD with questions
- `/project:generate-tasks [feature]` - 2-phase task generation
- `/project:process-tasks [file]` - One sub-task at a time processing

### Native Claude Commands
- `/clear` - Reset context between tasks
- `/undo` - Revert last change
- `/permissions` - Manage tool permissions

## File Naming Convention (Consistent with Cursor)
- **PRDs**: `prd-[feature-name].md`
- **Tasks**: `tasks-prd-[feature-name].md`  
- **Location**: `/tasks/` directory
- **Same naming as Cursor** for compatibility

## Setup Configuration

### Allowed Tools in `.claude/settings.json`
- File editing operations
- Git commands (add, commit, push, status, log)
- Package managers (npm, yarn, pnpm)
- MCP filesystem operations

### GitHub CLI Integration (Optional)
```bash
# Install GitHub CLI
brew install gh          # macOS
sudo apt install gh      # Ubuntu
gh auth login            # Configure
```

## Tips for Success

1. **Follow the Interactive Flow**: Don't rush through questions
2. **Respond to Confirmations**: "Go" for tasks, "yes"/"y" for sub-tasks
3. **One Thing at a Time**: No parallel work on multiple sub-tasks
4. **Use `/clear`** between different features to reset context
5. **Same as Cursor**: Workflow is identical for consistency

## Quality Standards
- Follow existing code patterns
- Implement proper error handling
- Add TypeScript types where applicable
- Test coverage for new code
- Update documentation as needed

Remember: The goal is **identical workflow** whether using Cursor or Claude Code!
EOF

    echo -e "${GREEN}✅ Reglas de Claude Code configuradas${NC}"
    echo -e "${GREEN}📁 Archivos creados:${NC}"
    echo "   - CLAUDE.md (instrucciones principales)"
    echo "   - claude_desktop_config.json (configuración MCP básica)"
    echo "   - .claude/settings.json (herramientas permitidas)"
            echo "   - .claude/commands/ (3 comandos core workflow)"
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
        echo "💡 Comandos disponibles (mismo flujo que Cursor):"
        echo "   • /project:create-prd [feature] - Crear PRD interactivo"
        echo "   • /project:generate-tasks [feature] - Generar tareas (2 fases)"
        echo "   • /project:process-tasks [file] - Procesar una subtarea a la vez"
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