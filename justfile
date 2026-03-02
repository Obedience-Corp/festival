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

# Sync all submodules to latest main and regenerate CLI docs
refresh:
    just git sync
    just docs all

