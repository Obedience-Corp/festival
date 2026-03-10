#!/usr/bin/env just --justfile
# festival - Festival Methodology CLI Distribution

set dotenv-load := true

# Modules
[doc('Build CLI binaries')]
mod build '.justfiles/build.just'

[doc('Run tests')]
mod test '.justfiles/test.just'

[doc('Documentation management')]
mod docs '.justfiles/docs.just'

[doc('Release management')]
mod release '.justfiles/release.just'

[doc('Submodule management')]
mod sub '.justfiles/sub.just'

[doc('Git operations')]
mod git '.justfiles/git.just'


[private]
default:
    #!/usr/bin/env bash
    echo "festival - Festival Methodology CLI Distribution"
    echo ""
    just --list --unsorted

# Pin submodules to latest stable tags and regenerate CLI docs
refresh:
    just release refresh-stable
    CLI_RELEASE_CHANNEL=stable just docs all

# Pin submodules to latest rc tags and regenerate stable-profile CLI docs
refresh-rc:
    just release refresh-rc
    CLI_RELEASE_CHANNEL=rc just docs all

# Pin submodules to latest prerelease tags and regenerate CLI docs
refresh-dev:
    just release refresh-dev
    CLI_PROFILE=dev CLI_RELEASE_CHANNEL=dev just docs all

# Sync submodules to latest main for development work and regenerate dev CLI docs
refresh-main:
    just git sync
    CLI_PROFILE=dev just docs all
