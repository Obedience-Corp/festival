# Festival Methodology

AI-native project planning with campaigns, festivals, phases, sequences, and tasks.

## What is Festival Methodology?

Festival Methodology is a hierarchical planning system built for human-AI collaboration. It provides structure for long-running autonomous development cycles and complex project orchestration.

The methodology defines five levels of planning granularity:

| Level | Managed By | Purpose |
|-------|-----------|---------|
| **Campaign** | `camp` | Workspace containing multiple projects and festivals |
| **Festival** | `fest` | Goal-oriented project plan with defined phases |
| **Phase** | `fest` | Major stage of work within a festival |
| **Sequence** | `fest` | Ordered set of tasks within a phase |
| **Task** | `fest` | Individual unit of work with a defined lifecycle |

## CLI Tools

### fest

The festival planning and execution CLI. Create festivals, define phases and sequences, track progress, and execute task workflows.

### camp

The campaign workspace manager. Initialize campaign workspaces, navigate between projects, and coordinate multiple festivals.

## Getting Started

- [Installation](getting-started/installation.md) — Install fest and camp
- [Quick Start](getting-started/quickstart.md) — Create your first festival
- [Shell Setup](getting-started/shell-setup.md) — Enable shell integration
