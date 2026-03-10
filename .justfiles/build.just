# Build commands
cli_profile := env("CLI_PROFILE", "stable")

# Show available build commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Build both CLIs
[no-cd]
all: fest camp
    @echo "Both CLIs built"

# Build fest
[no-cd]
fest:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{cli_profile}}" in
        stable) cd fest && just build quick-stable ;;
        dev) cd fest && just build quick-dev ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac

# Build camp
[no-cd]
camp:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{cli_profile}}" in
        stable) cd camp && just build quick-stable ;;
        dev) cd camp && just build quick-dev ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac
