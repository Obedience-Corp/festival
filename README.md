# Festival

![Festival Banner](docs/images/festival_banner.png)

**AI-native project planning with campaigns, festivals, phases, sequences, and tasks.**

Festival is a hierarchical planning system designed for human-AI collaboration, long-running autonomous development cycles, and complex project orchestration.

This repository is the distribution hub for the Festival CLI tools:

- **fest** — Create, plan, execute, and track festivals
- **camp** — Manage campaign workspaces that organize multiple festivals

## Install

**macOS:**

```bash
brew install lancekrogers/tap/festival
```

**Arch Linux:**

```bash
yay -S festival-bin
```

**Debian/Ubuntu:** Download `.deb` from [releases](https://github.com/Obedience-Corp/festival/releases/latest)

**Windows:**

```powershell
scoop bucket add obey https://github.com/lancekrogers/scoop-bucket
scoop install festival
```

See the [installation guide](https://obedience-corp.github.io/festival/install/) for all platforms and methods.

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

Full documentation is available at the [Festival docs site](https://obedience-corp.github.io/festival).

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
