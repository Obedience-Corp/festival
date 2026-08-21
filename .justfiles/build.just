# Build commands
cli_profile := env("CLI_PROFILE", "stable")

# Show available build commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Build all three CLIs
[no-cd]
all: fest camp festival-installer
    @echo "All three CLIs built"

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
        # VERSION stamps the pinned tag into the binary; camp's own recipe
        # defaults it to "dev", which would make a correctly pinned bundle
        # binary report the wrong version.
        stable) cd camp && VERSION="$(git describe --tags --always)" just build quick-stable ;;
        dev) cd camp && just build quick-dev ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac

# Build the festival hub
[no-cd]
festival-installer:
    #!/usr/bin/env bash
    set -euo pipefail
    # The hub has no quick-stable/quick-dev build-tag split like fest and camp
    # (it has one plain `just build`), so both profiles build the same way.
    # VERSION stamps the pinned tag into main.version, matching the ldflag
    # .goreleaser.yaml uses for the release archives.
    case "{{cli_profile}}" in
        stable | dev)
            version="$(cd festival-installer && git describe --tags --always)"
            (cd festival-installer && go build -ldflags "-X main.version=${version}" -o bin/festival ./cmd/festival)
            ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac
