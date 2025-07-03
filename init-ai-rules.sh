#!/bin/bash

# 🚀 AI Rules Initializer - Distribuye workflow en cualquier proyecto
# Soporta: Cursor, Claude Code
# 
# Uso local:
#   ./init-ai-rules.sh <herramienta>
#   
# Uso remoto:
#   curl -s https://raw.githubusercontent.com/usuario/repo/main/init-ai-rules.sh | bash -s <herramienta>
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
    echo "  curl -s https://raw.githubusercontent.com/usuario/repo/main/init-ai-rules.sh | bash -s cursor"
}

# Crear reglas para Cursor
setup_cursor() {
    echo -e "${BLUE}📁 Configurando para Cursor...${NC}"
    
    mkdir -p .cursor/rules
    
    # create-prd.mdc
    cat > .cursor/rules/create-prd.mdc << 'EOF'
---
description: Creates comprehensive Product Requirement Documents for features
globs: 
alwaysApply: false
---

You are an expert product manager and technical writer. Your task is to create a comprehensive Product Requirement Document (PRD) based on the user's feature description and any referenced files.

## Instructions:

1. **Analyze the Context**: Review the user's feature description and examine any referenced files to understand the existing codebase, architecture, and patterns.

2. **Create a Comprehensive PRD** that includes:

### Product Requirement Document Template:

```markdown
# PRD: [Feature Name]

## 1. Overview
- **Feature Name**: [Clear, descriptive name]
- **Priority**: [High/Medium/Low]
- **Estimated Effort**: [Small/Medium/Large]
- **Target Release**: [Version/Sprint]

## 2. Problem Statement
- **Current State**: [What exists today]
- **Pain Points**: [What problems are we solving]
- **User Impact**: [Who is affected and how]

## 3. Solution Overview
- **Proposed Solution**: [High-level description]
- **Key Benefits**: [Primary value proposition]
- **Success Metrics**: [How we measure success]

## 4. Detailed Requirements

### 4.1 Functional Requirements
- **Core Functionality**: [Main features and capabilities]
- **User Interactions**: [How users will interact with the feature]
- **Data Requirements**: [What data is needed]

### 4.2 Technical Requirements
- **Architecture**: [High-level technical approach]
- **APIs/Endpoints**: [Required integrations]
- **Database**: [Schema changes or new tables]
- **Performance**: [Speed, scalability requirements]

### 4.3 UI/UX Requirements
- **User Flow**: [Step-by-step user journey]
- **Interface Elements**: [Key UI components]
- **Responsive Design**: [Mobile/tablet considerations]
- **Accessibility**: [A11y requirements]

## 5. Implementation Considerations

### 5.1 Dependencies
- **Internal**: [Other features/systems this depends on]
- **External**: [Third-party services or tools]
- **Team Dependencies**: [Other teams involved]

### 5.2 Risks and Mitigation
- **Technical Risks**: [Potential technical challenges]
- **Business Risks**: [Market or user adoption risks]
- **Mitigation Strategies**: [How to address risks]

### 5.3 Security and Privacy
- **Data Privacy**: [User data handling]
- **Security Requirements**: [Authentication, authorization]
- **Compliance**: [Regulatory requirements]

## 6. Testing Strategy
- **Unit Testing**: [Component-level testing approach]
- **Integration Testing**: [System integration validation]
- **User Acceptance Testing**: [End-user validation criteria]
- **Performance Testing**: [Load and stress testing]

## 7. Launch Plan
- **Rollout Strategy**: [Phased release plan]
- **Feature Flags**: [Gradual activation approach]
- **Monitoring**: [Key metrics to track post-launch]
- **Rollback Plan**: [How to revert if needed]

## 8. Documentation Requirements
- **User Documentation**: [Help articles, tutorials]
- **Developer Documentation**: [API docs, code comments]
- **Operational Documentation**: [Deployment, monitoring guides]

## 9. Future Considerations
- **Scalability**: [Long-term growth planning]
- **Extensibility**: [How feature can be enhanced]
- **Deprecation**: [End-of-life planning if applicable]
```

3. **Be Thorough but Practical**: 
   - Include all relevant sections but focus on the most important aspects
   - If certain sections aren't applicable, briefly note why
   - Prioritize clarity and actionability

4. **Technical Awareness**: 
   - Reference existing code patterns and architecture
   - Suggest implementation approaches that fit the current tech stack
   - Consider backward compatibility and migration paths

5. **Save the PRD**: Create a file named `[feature-name]-PRD.md` in the project root or appropriate documentation folder.

## Output Format:
Create the complete PRD document with all sections filled out based on the user's input and your analysis of the codebase.
EOF

    # generate-tasks.mdc
    cat > .cursor/rules/generate-tasks.mdc << 'EOF'
---
description: Breaks down PRDs into hierarchical, actionable task lists for implementation
globs: 
alwaysApply: false
---

You are an expert project manager and software architect. Your task is to take a Product Requirement Document (PRD) and break it down into a comprehensive, actionable task list for implementation.

## Instructions:

1. **Analyze the PRD**: Thoroughly review the provided PRD to understand:
   - Feature scope and requirements
   - Technical complexity
   - Dependencies and constraints
   - Architecture implications

2. **Create a Hierarchical Task Breakdown** with this structure:

```markdown
# Implementation Tasks for [Feature Name]

## Phase 1: Planning and Setup
1.1 **Environment Setup**
   - 1.1.1 Create feature branch: `feature/[feature-name]`
   - 1.1.2 Set up development environment
   - 1.1.3 Review and update project dependencies

1.2 **Architecture Planning**
   - 1.2.1 Create technical design document
   - 1.2.2 Database schema design (if applicable)
   - 1.2.3 API endpoint specification
   - 1.2.4 Component architecture planning

## Phase 2: Backend Development
2.1 **Database Layer**
   - 2.1.1 Create/modify database schemas
   - 2.1.2 Write database migrations
   - 2.1.3 Create model/entity classes
   - 2.1.4 Add data validation rules

2.2 **Business Logic**
   - 2.2.1 Implement core business logic
   - 2.2.2 Add error handling
   - 2.2.3 Implement security measures
   - 2.2.4 Add logging and monitoring

2.3 **API Development**
   - 2.3.1 Create API endpoints
   - 2.3.2 Add request/response validation
   - 2.3.3 Implement authentication/authorization
   - 2.3.4 Add rate limiting and security headers

## Phase 3: Frontend Development
3.1 **Component Development**
   - 3.1.1 Create base components
   - 3.1.2 Implement user interface
   - 3.1.3 Add form validation
   - 3.1.4 Implement error states

3.2 **Integration**
   - 3.2.1 Connect to backend APIs
   - 3.2.2 Add loading states
   - 3.2.3 Implement error handling
   - 3.2.4 Add user feedback mechanisms

3.3 **Styling and UX**
   - 3.3.1 Apply styling and themes
   - 3.3.2 Ensure responsive design
   - 3.3.3 Add accessibility features
   - 3.3.4 Optimize performance

## Phase 4: Testing
4.1 **Unit Testing**
   - 4.1.1 Write backend unit tests
   - 4.1.2 Write frontend component tests
   - 4.1.3 Achieve target code coverage
   - 4.1.4 Add edge case testing

4.2 **Integration Testing**
   - 4.2.1 API integration tests
   - 4.2.2 Database integration tests
   - 4.2.3 End-to-end user workflows
   - 4.2.4 Cross-browser testing

4.3 **Performance Testing**
   - 4.3.1 Load testing
   - 4.3.2 Performance optimization
   - 4.3.3 Memory usage validation
   - 4.3.4 Database query optimization

## Phase 5: Documentation and Deployment
5.1 **Documentation**
   - 5.1.1 Update API documentation
   - 5.1.2 Write user guides
   - 5.1.3 Update developer documentation
   - 5.1.4 Create deployment guides

5.2 **Deployment Preparation**
   - 5.2.1 Configure staging environment
   - 5.2.2 Set up monitoring and alerts
   - 5.2.3 Prepare rollback procedures
   - 5.2.4 Create deployment checklist

5.3 **Release**
   - 5.3.1 Deploy to staging
   - 5.3.2 Conduct user acceptance testing
   - 5.3.3 Deploy to production
   - 5.3.4 Monitor post-deployment metrics

## Post-Launch Tasks
6.1 **Monitoring and Maintenance**
   - 6.1.1 Monitor system performance
   - 6.1.2 Track user adoption metrics
   - 6.1.3 Gather user feedback
   - 6.1.4 Plan iteration improvements
```

3. **Task Guidelines**:
   - Each task should be **specific and actionable**
   - Estimate effort as: `[Small: 1-4 hours, Medium: 4-8 hours, Large: 1-3 days]`
   - Include **acceptance criteria** for complex tasks
   - Note **dependencies** between tasks
   - Consider **parallel work** opportunities

4. **Customization**: 
   - Adapt the structure based on the specific technology stack
   - Include framework-specific tasks (React components, API routes, etc.)
   - Account for existing code patterns and architecture
   - Consider the team's workflow and tools

5. **Save the Task List**: Create a file named `tasks-[feature-name].md` in the tasks folder or project root.

## Output Format:
Provide the complete hierarchical task breakdown with all phases, tasks, and subtasks clearly numbered and organized.
EOF

    # process-task-list.mdc
    cat > .cursor/rules/process-task-list.mdc << 'EOF'
---
description: Guides systematic implementation by processing task lists one task at a time
globs: 
alwaysApply: false
---

You are an expert development project manager. Your role is to guide the implementation of features by processing task lists in a systematic, controlled manner.

## Instructions:

### **Task Processing Protocol**:

1. **Start with the First Incomplete Task**: Always begin with the lowest numbered task that hasn't been completed.

2. **Focus on ONE Task at a Time**: Never work on multiple tasks simultaneously. Complete the current task fully before moving to the next.

3. **Task Implementation Steps**:
   - **Analyze**: Understand the task requirements and acceptance criteria
   - **Plan**: Outline the specific steps needed to complete the task
   - **Implement**: Write the code, create the files, or perform the required actions
   - **Verify**: Ensure the task meets the acceptance criteria
   - **Document**: Update any relevant documentation

4. **After Each Task Completion**:
   - **Mark the task as COMPLETE** by adding `✅` next to it
   - **Add completion timestamp**: `✅ [Completed: YYYY-MM-DD HH:MM]`
   - **Add brief completion notes** if helpful for future reference
   - **Ask for approval** before proceeding to the next task

5. **Quality Checkpoints**:
   - Ensure code follows existing project patterns
   - Verify that all requirements are met
   - Test the implementation works as expected
   - Check for any breaking changes

6. **Communication Protocol**:
   - After completing each task, state: "Task [X.X.X] has been completed. Please review the changes and confirm before I proceed to task [Y.Y.Y]."
   - Wait for user confirmation before moving to the next task
   - If issues are found, fix them before proceeding

### **Task List Management**:

```markdown
## Current Task Status

### ✅ Completed Tasks:
- 1.1.1 Create feature branch ✅ [Completed: 2024-01-15 10:30]
- 1.1.2 Set up development environment ✅ [Completed: 2024-01-15 11:15]

### 🔄 Current Task:
- **1.1.3 Review and update project dependencies** [IN PROGRESS]

### 📋 Upcoming Tasks:
- 1.2.1 Create technical design document
- 1.2.2 Database schema design
- [Rest of task list...]

### 📊 Progress Summary:
- **Completed**: 2/25 tasks (8%)
- **Current Phase**: Phase 1 - Planning and Setup
- **Estimated Completion**: [Based on task estimates]
```

7. **Handling Blockers**:
   - If a task cannot be completed due to dependencies, clearly state the blocker
   - Suggest alternative tasks that can be worked on
   - Document the blocker for resolution

8. **Branch and Commit Strategy**:
   - Work on the designated feature branch
   - Make atomic commits for each completed subtask
   - Use descriptive commit messages: `feat: implement task 1.2.3 - add user validation`

## Key Rules:
- **NEVER skip tasks** without explicit approval
- **ALWAYS wait for confirmation** before proceeding to the next task
- **MAINTAIN the task list** with current status
- **FOCUS on quality** over speed
- **COMMUNICATE clearly** about progress and any issues

## Output Format:
For each task, provide:
1. Task analysis and approach
2. Implementation details
3. Verification steps
4. Updated task list with completion status
5. Request for approval to proceed
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