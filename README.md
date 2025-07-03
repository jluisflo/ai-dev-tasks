# 🚀 AI Rules Initializer - Setup de Workflow para Cursor y Claude Code

Un script bash que configura automáticamente flujos de trabajo estructurados para desarrollo con IA en **Cursor** y **Claude Code**. Convierte el desarrollo caótico en un proceso sistemático: **PRD → Tareas → Implementación**.

## ✨ ¿Por qué usar este script?

Desarrollar features complejas con IA puede ser impredecible. Este script soluciona esto implementando un workflow estructurado:

1. **📋 Definir Alcance**: PRD (Product Requirement Document) claro
2. **🎯 Planificación Detallada**: Desglose en tareas granulares y accionables  
3. **⚡ Implementación Iterativa**: Una tarea a la vez, con checkpoints de calidad

**Resultado**: Desarrollo más confiable, controlado y eficiente con IA.

## 🛠️ Herramientas Soportadas

| Herramienta | Soporte | Comandos Personalizados | Configuración |
|------------|---------|-------------------------|---------------|
| **Cursor** | ✅ Completo | `.mdc` rules | `.cursor/rules/` |
| **Claude Code** | ✅ Completo | 3 slash commands | `CLAUDE.md` + MCP |

## 📦 Instalación

### Prerrequisitos

#### Para Cursor:
```bash
# 1. Descargar Cursor
# Visita: https://cursor.sh/
# 2. Instalar y configurar cuenta Pro (recomendado)
```

#### Para Claude Code:
```bash
# 1. Claude Pro (requerido)
# Visita: https://claude.ai/

# 2. Node.js (para servidores MCP)
# Visita: https://nodejs.org/

# 3. GitHub CLI (opcional pero recomendado)
# macOS:
brew install gh

# Ubuntu:
sudo apt install gh

# Windows:
winget install GitHub.cli

# Configurar después de instalar:
gh auth login
```

### Quick Setup

```bash
# 1. Clonar o descargar  
git clone https://github.com/jluisflo/ai-dev-tasks.git
cd ai-dev-tasks

# 2. Dar permisos de ejecución
chmod +x init-ai-rules.sh

# 3. Ejecutar para tu herramienta
./init-ai-rules.sh cursor    # Para Cursor
./init-ai-rules.sh claude    # Para Claude Code
```

### Uso Remoto (Una Línea)

```bash
# Para Cursor
curl -s https://raw.githubusercontent.com/jluisflo/ai-dev-tasks/refs/heads/main/init-ai-rules.sh -o /tmp/init-ai-rules.sh && chmod +x /tmp/init-ai-rules.sh && /tmp/init-ai-rules.sh cursor

# Para Claude Code  
curl -s https://raw.githubusercontent.com/jluisflo/ai-dev-tasks/refs/heads/main/init-ai-rules.sh -o /tmp/init-ai-rules.sh && chmod +x /tmp/init-ai-rules.sh && /tmp/init-ai-rules.sh claude
```

## 🎯 Uso del Script

### Ayuda del Script
```bash
./init-ai-rules.sh
# Muestra ayuda con opciones disponibles
```

### Configuración para Cursor
```bash
./init-ai-rules.sh cursor
```

**Archivos creados:**
- `.cursor/rules/create-prd.mdc` - Creación interactiva de PRDs
- `.cursor/rules/generate-tasks.mdc` - Generación de tareas en 2 fases  
- `.cursor/rules/process-task-list.mdc` - Procesamiento una subtarea a la vez
- `tasks/` - Carpeta para PRDs y listas de tareas

### Configuración para Claude Code
```bash
./init-ai-rules.sh claude
```

**Archivos creados:**
- `CLAUDE.md` - Instrucciones principales del workflow
- `claude_desktop_config.json` - Configuración MCP básica
- `.claude/settings.json` - Herramientas permitidas
- `.claude/commands/` - 3 comandos core workflow
- `.claude/best-practices.md` - Guía de mejores prácticas
- `tasks/` - Carpeta para listas de tareas

## 🚀 Workflow Completo

### Para Cursor

#### 1. Crear PRD (Interactivo)
```text
Usando @create-prd.mdc
Crearun PRD para un sistema de comentarios con moderación automática
```
**El AI te hará preguntas clarificadoras** antes de generar el PRD. Responde con opciones numeradas para facilitar la selección.

#### 2. Generar Tareas (2 Fases)
```text
Toma @prd-comentarios-system.md y genera las tareas basado en @generate-tasks.mdc
```
**Proceso en 2 pasos:**
1. Primero genera tareas principales (parent tasks)
2. Pregunta si continuar → Responde **"Go"**  
3. Genera subtareas detalladas

#### 3. Procesar Tareas (Una por una)
```text
Empezar con la primera subtarea de @tasks-prd-comentarios-system.md utilizando @process-task-list.mdc
```
**El AI trabajará una subtarea a la vez** y esperará tu aprobación ("yes"/"y") antes de continuar.

### Para Claude Code

#### 1. Crear PRD (Interactivo)
```bash
/create-prd crear un sistema de comentarios con moderación automática
```
**Claude te hará preguntas clarificadoras** antes de generar el PRD. Proporciona detalles para cada pregunta.

#### 2. Generar Tareas (2 Fases)
```bash
/generate-tasks [nombre-del-prd]
```
**Proceso automático en 2 pasos:**
1. Genera tareas principales (parent tasks)
2. Espera tu confirmación → Responde **"Go"**
3. Genera subtareas detalladas

#### 3. Procesar Tareas (Una por una)
```text
/process-tasks comienza a procesar la primera subtarea de tasks-prd-comentarios-system.md
```
**Claude trabajará una subtarea a la vez** y esperará tu aprobación antes de continuar.

## 🎮 Comandos Personalizados de Claude

### Comandos del Workflow Principal
```bash
/create-prd [descripción del feature]
# Crea PRD completo con todas las secciones

/generate-tasks [nombre-del-feature]
# Genera desglose jerárquico de tareas desde el PRD
```

### Comandos de Procesamiento
```bash
/process-tasks [archivo-de-tareas]
# Procesa tareas una subtarea a la vez con confirmaciones
```

### Comandos Nativos de Claude
```bash
/clear          # Limpiar contexto entre tareas
/undo           # Revertir último cambio
/permissions    # Gestionar herramientas permitidas
```

## 📁 Estructura de Archivos Creados

### Para Cursor
```
.cursor/
├── rules/
│   ├── create-prd.mdc           # PRD creation
│   ├── generate-tasks.mdc       # Task breakdown
│   └── process-task-list.mdc    # Systematic processing
└── tasks/                       # Task lists storage
```

### Para Claude Code
```
CLAUDE.md                        # Main workflow instructions
claude_desktop_config.json       # MCP configuration
.claude/
├── settings.json               # Allowed tools
├── commands/                   # Custom slash commands
│   ├── create-prd.md
│   ├── generate-tasks.md
│   └── process-tasks.md
├── best-practices.md           # Essential guide
└── project-instructions.md     # Project-specific setup
tasks/                          # Task lists storage
```

## 🔄 Ejemplo de Workflow Completo

### 1. Configuración Inicial
```bash
# Ejecutar en tu proyecto
./init-ai-rules.sh claude
```

### 2. Desarrollo de Feature
```bash
# Crear PRD (responder preguntas clarificadoras)
/create-prd sistema de notificaciones push

# Revisar PRD generado: prd-notificaciones-push.md

# Generar tareas (proceso en 2 fases)
/generate-tasks notificaciones-push
# 1. Genera parent tasks
# 2. Responder "Go" 
# 3. Genera subtareas

# Revisar tareas generadas: tasks-prd-notificaciones-push.md
```

### 3. Implementación Sistemática
```text
Por favor, comienza con la primera subtarea de tasks-prd-notificaciones-push.md

# Claude procesará subtarea por subtarea:
# ✅ 1.1 [x] Setup development environment  
# 🔄 1.2 [ ] Create technical design document [EN PROGRESO]
# 📋 1.3 [ ] Database schema design [PENDIENTE]
# (Esperará "yes"/"y" entre cada subtarea)
```

### 4. Procesamiento de Tareas
```bash
# Procesar tareas una por una
/process-tasks tasks-prd-notificaciones-push.md
```

## 💡 Mejores Prácticas

### Para Cursor
- **Responde preguntas clarificadoras** para PRDs más precisos
- Usa **MAX mode** para análisis más profundos
- Responde **"Go"** cuando se solicite para generar subtareas
- Confirma **"yes"/"y"** entre cada subtarea durante implementación

### Para Claude Code
- **Proporciona detalles completos** en preguntas clarificadoras
- Usa `/clear` entre tareas diferentes para resetear contexto
- Responde **"Go"** para proceder a generar subtareas
- Configura herramientas permitidas en `.claude/settings.json`

### Ambas Herramientas
- **Interactúa activamente**: El workflow requiere tu participación
- **Una subtarea a la vez**: Evita trabajar en paralelo
- **Revisa cada paso**: Calidad sobre velocidad
- **Nomenclatura consistente**: `prd-[nombre].md` y `tasks-prd-[nombre].md`

## 🔧 Personalización

### Modificar Comandos de Claude
Edita archivos en `.claude/commands/` para personalizar comportamiento:

```bash
# Ejemplo: Modificar comando de PRD
nano .claude/commands/create-prd.md
```

### Configurar Herramientas Permitidas
```json
// .claude/settings.json
{
  "allowedTools": [
    "Edit",
    "Bash(git*)",
    "Bash(npm*)",
    "mcp__filesystem__*"
  ]
}
```

### Personalizar Workflow
Edita `CLAUDE.md` para adaptar el workflow a tu proyecto específico.

## 🤝 Contribuciones

1. Crear feature branch
2. Realizar cambios
3. Enviar Pull Request

## 📞 Soporte

- **Issues**: Para reportar bugs o sugerir mejoras
- **Discussions**: Para preguntas sobre uso y mejores prácticas

---

## 🎯 Próximos Pasos

1. **Configura tu herramienta**: `./init-ai-rules.sh cursor` o `./init-ai-rules.sh claude`
2. **Prueba el workflow**: Crea un PRD simple
3. **Experimenta con comandos**: Usa los slash commands en Claude
4. **Adapta a tu proyecto**: Modifica según tus necesidades

¡Transforma tu desarrollo con IA de caótico a sistemático! 🚀 