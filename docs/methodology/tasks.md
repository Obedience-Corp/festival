# Tasks

Tasks are the atomic work units of the Festival Methodology, sitting at the bottom of the hierarchy: **Campaign > Festival > Phase > Sequence > Task**.

## What is a Task?

Tasks are NOT single to-dos. They are comprehensive work units -- think of them like a Claude Code plan. Each task document contains multiple actions, acceptance criteria, context, and testing commands. A task is a self-contained blueprint that tells a developer (human or AI) exactly what to build, how to verify it, and what "done" looks like.

Tasks use 2-digit numbering within their parent sequence: `01_create_user_model.md`, `02_add_auth_middleware.md`, `03_implement_login_endpoint.md`. The numbering defines execution order. Dependencies between tasks are explicit.

## The Implementation-Ready Principle

Every task must be **implementation-ready**. A developer can start coding immediately without needing additional clarification or research.

The litmus test: can someone copy-paste the code examples and commands from your task and get working results? If the answer is no, the task needs more detail.

Implementation-ready means:

- File paths are real, not placeholders
- Code examples compile and run
- Commands are copy-pasteable
- Schemas include actual column names and types
- Config values are concrete, not `<YOUR_VALUE_HERE>`

If you find yourself writing "TBD", "see docs", or "figure out the best approach" -- the task is not ready. Push that research into a planning phase or a prerequisite task.

## Task Document Structure

A good task document includes five sections:

- **Objective**: Specific, concrete description of what to build. One or two sentences. No ambiguity.
- **Requirements**: Checklist of specific items with exact file paths, schemas, and patterns. Each requirement is verifiable -- you can look at it and say "yes, this exists" or "no, it doesn't."
- **Implementation Steps**: Numbered steps with actual commands to run. These follow a logical order and reference real files in the project. Include code snippets where the implementation is non-obvious.
- **Testing Commands**: Exact commands to verify the work. Not "run the tests" -- the actual command with flags and file paths.
- **Deliverables**: Checklist of specific files that should exist when done. This is the completion gate.

## Good vs Bad Examples

**BAD** -- abstract, vague, impossible to act on:

```markdown
# Task: 01_user_management.md
## Objective
Implement user management functionality
## Requirements
- [ ] Create user system
- [ ] Add authentication
- [ ] Handle user data
```

This tells you nothing. What user system? What kind of authentication? A developer reading this has to make dozens of decisions that should already be made.

**GOOD** -- concrete, specific, immediately actionable:

```markdown
# Task: 01_create_user_table_and_model.md
## Objective
Create PostgreSQL user table and Sequelize model with email/password authentication fields.
## Requirements
- [ ] Create `users` table with id (UUID, PK), email (VARCHAR(255), UNIQUE, NOT NULL),
      password_hash (VARCHAR(255), NOT NULL), created_at, updated_at
- [ ] Create `models/User.js` with Sequelize model definition
- [ ] Add email validation with regex: /^[^\s@]+@[^\s@]+\.[^\s@]+$/
- [ ] Add bcrypt password hashing with salt rounds = 12
## Implementation Steps
1. Run: `npx sequelize-cli migration:generate --name create-users-table`
2. Edit migration file with SQL schema
3. Create `models/User.js` with Sequelize model
4. Add bcrypt dependency: `npm install bcrypt`
## Testing Commands
npm test -- tests/models/User.test.js
## Deliverables
- [ ] `migrations/001_create_users_table.js`
- [ ] `models/User.js`
- [ ] `tests/models/User.test.js`
```

Every requirement maps to something you can verify. Every step produces a concrete result.

## Complexity Levels

**Level 1 -- Single File.** Creating individual files, small components, utility functions. A validation helper, a database migration, a config file. These tasks are short -- objective, a few requirements, the file path, and a test command.

**Level 2 -- Multi-File.** API endpoints, components with styling, database operations spanning model + migration + test. These tasks need clear file listings and explicit wiring between the pieces.

**Level 3 -- Feature.** Complete features spanning multiple files and systems. This is the upper bound of what a single task should contain. If you're going beyond this, split into multiple tasks. These benefit from a "Current State" section describing what exists before the task starts.

## Common Mistakes

**Using placeholders instead of real values.**
Bad: `interface [ComponentName]Props`. Good: `interface LoginFormProps`.

**Abstract requirements.**
Bad: "Handle user authentication." Good: "Implement JWT auth with 7-day token expiry using `jsonwebtoken`, refresh tokens stored in `refresh_tokens` table."

**Missing implementation details.**
Bad: "Create database schema." Good: The actual SQL with column names, types, constraints, and indexes.

**Vague testing instructions.**
Bad: "Test the feature." Good: `go test ./internal/auth/... -v -run TestLoginHandler`.

**Scope creep.** If a task document exceeds ~200 lines, it covers too much. Split it.

**Missing dependencies.** If Task 03 requires the database table from Task 01, say so explicitly in the header.

## Rules Compliance

Each task should reference relevant rules from the festival's `FESTIVAL_RULES.md`. This keeps implementation consistent with coding standards, naming conventions, and architectural decisions.

### Pre-Task Checklist

Before starting a task:

- [ ] All dependency tasks are marked complete
- [ ] The objective is clear and unambiguous
- [ ] Required files and modules from prior tasks exist
- [ ] Development environment matches task assumptions
- [ ] FESTIVAL_RULES.md has been reviewed for applicable standards

### Completion Checklist

Before marking a task done:

- [ ] All deliverable files exist at the specified paths
- [ ] All requirements checkboxes are satisfied
- [ ] Testing commands pass
- [ ] Code follows FESTIVAL_RULES.md standards
- [ ] No leftover TODOs, placeholders, or hardcoded dev values
- [ ] Changes are committed with a descriptive message

## Task Lifecycle

Tasks move through a simple status progression:

```
NOT STARTED → IN PROGRESS → COMPLETE
```

A task can also be marked `BLOCKED` (dependency unresolved) or `SKIPPED` (no longer needed). Status is tracked in the task document header and reflected in `fest status` output.

When an agent completes a task, the deliverables checklist serves as the verification gate. Every box checked means the task is done. No ambiguity, no judgment calls.
