## camp init

Initialize a new campaign

### Synopsis

Initialize a new campaign directory structure.

Creates the standard campaign directories:
  .campaign/              - Campaign configuration and metadata
  projects/               - Project repositories (submodules or worktrees)
  projects/worktrees/     - Git worktrees for parallel development
  festivals/              - Festival methodology workspace (via fest init)
  ai_docs/                - AI-generated documentation
  docs/                   - Human-authored documentation
  dungeon/                - Archived and deprioritized work
  workflow/               - Workflow management
  workflow/code_reviews/  - Code review notes and feedback
  workflow/pipelines/     - CI/CD pipeline definitions
  workflow/design/        - Design documents
  workflow/intents/       - Intent documents

Also creates:
  AGENTS.md     - AI agent instruction file
  CLAUDE.md     - Symlink to AGENTS.md

Initializes a git repository if not already inside one.

Use --no-git to skip git initialization.

```
camp init [path] [flags]
```

### Examples

```
  camp init                      Initialize current directory
  camp init my-campaign          Create and initialize new directory
  camp init --name "My Project"  Set custom campaign name
  camp init --no-git             Skip git initialization
  camp init --dry-run            Preview without creating anything
```

### Options

```
  -d, --description string   Campaign description
      --dry-run              Show what would be done without creating anything
  -f, --force                Initialize in non-empty directory without prompting
  -h, --help                 help for init
  -m, --mission string       Campaign mission statement
  -n, --name string          Campaign name (defaults to directory name)
      --no-git               Skip git repository initialization
      --no-register          Don't add to global registry
      --repair               Add missing files to existing campaign
      --skip-fest            Skip automatic Festival Methodology initialization
  -t, --type string          Campaign type (product, research, tools, personal) (default "product")
      --yes                  Skip repair confirmation prompt (for scripting)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

