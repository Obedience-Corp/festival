# Festival Methodology

**AI-native project planning with campaigns, festivals, phases, sequences, and tasks.**

Festival Methodology is a hierarchical planning system designed for human-AI collaboration, long-running autonomous development cycles, and complex project orchestration.

This repository is the distribution hub for the Festival CLI tools:

- **fest** — Create, plan, execute, and track festivals
- **camp** — Manage campaign workspaces that organize multiple festivals

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Obedience-Corp/festival/main/install.sh | bash
```

Or with Homebrew:

```bash
brew install lancekrogers/tap/festival
```

## Quick Start

```bash
# Set up shell integration
eval "$(fest shell-init zsh)"
eval "$(camp shell-init zsh)"

# Create a campaign workspace
camp init my-project

# Create your first festival
fest create festival my-first-festival

# Learn the methodology
fest understand
```

## Documentation

Full documentation is available at the [Festival Methodology docs site](https://obedience-corp.github.io/festival).

## Hierarchy

```
Campaign → Festival → Phase → Sequence → Task
```

- **Campaign** — A workspace containing multiple related projects and festivals
- **Festival** — A goal-oriented project plan with defined phases
- **Phase** — A major stage of work within a festival
- **Sequence** — An ordered set of tasks within a phase
- **Task** — An individual unit of work with a defined lifecycle

## License

[Business Source License 1.1](LICENSE)

Built by [Obedience Corp](https://obediencecorp.com) — AI that does what you want, the way you want it done.
