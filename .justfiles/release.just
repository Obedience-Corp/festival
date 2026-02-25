# Release management

# Show available release commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Run GoReleaser dry run (no publish)
[no-cd]
dry-run:
    goreleaser release --snapshot --clean

# Create a release tag
[no-cd]
tag version:
    git tag -a v{{version}} -m "Release v{{version}}"
    @echo "Tagged v{{version}} — push with: git push origin v{{version}}"

# Full release (CI should handle this, but for manual use)
[no-cd]
publish:
    goreleaser release --clean
