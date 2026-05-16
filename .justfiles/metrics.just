#!/usr/bin/env just --justfile
# Distribution metrics

npm_package := env("FESTIVAL_NPM_PACKAGE", "@obedience-corp/festival")
homebrew_cask := env("FESTIVAL_HOMEBREW_CASK", "obedience-corp/tap/festival")
github_repo := env("FESTIVAL_GITHUB_REPO", "Obedience-Corp/festival")

[private]
default:
    @just --list --justfile {{source_file()}}

# Show the main Festival distribution metrics
[no-cd]
summary:
    @just --justfile {{source_file()}} homebrew
    @echo ""
    @just --justfile {{source_file()}} npm
    @echo ""
    @just --justfile {{source_file()}} github

# Show Homebrew cask install analytics for Festival
[no-cd]
homebrew cask=homebrew_cask:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
    command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

    echo "Homebrew cask analytics: {{cask}}"
    printf "%-8s %-12s %-12s %10s %8s\n" "window" "start" "end" "installs" "rank"
    for days in 30 90 365; do
        json="$(curl -fsSL "https://formulae.brew.sh/api/analytics/cask-install/${days}d.json")"
        row="$(
            jq -r --arg cask "{{cask}}" --arg days "${days}d" '
                . as $root
                | .items[]?
                | select(.cask == $cask)
                | [$days, $root.start_date, $root.end_date, .count, (.number | tostring)]
                | @tsv
            ' <<<"$json"
        )"
        if [ -n "$row" ]; then
            printf "%-8s %-12s %-12s %10s %8s\n" $row
        else
            printf "%-8s %-12s %-12s %10s %8s\n" "${days}d" "-" "-" "0" "-"
        fi
    done

# Show npm package metadata and download windows
[no-cd]
npm package=npm_package:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v curl >/dev/null || { echo "curl is required" >&2; exit 1; }
    command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

    package="{{package}}"
    encoded="${package//@/%40}"
    encoded="${encoded//\//%2F}"

    echo "npm package: ${package}"
    if command -v npm >/dev/null && metadata="$(npm view "$package" version license dist-tags --json 2>/dev/null)"; then
        jq -r '"version: " + (.version // "unknown"), "license: " + (.license // "unknown"), "dist-tags: " + ((."dist-tags" // {}) | tojson)' <<<"$metadata"
    else
        echo "metadata: unavailable"
    fi

    echo ""
    printf "%-12s %10s %-12s %-12s\n" "window" "downloads" "start" "end"
    for period in last-week last-month; do
        if json="$(curl -fsSL "https://api.npmjs.org/downloads/point/${period}/${encoded}" 2>/dev/null)"; then
            jq -r --arg period "$period" '[ $period, (.downloads | tostring), .start, .end ] | @tsv' <<<"$json" |
                while IFS=$'\t' read -r window downloads start end; do
                    printf "%-12s %10s %-12s %-12s\n" "$window" "$downloads" "$start" "$end"
                done
        else
            printf "%-12s %10s %-12s %-12s\n" "$period" "unavailable" "-" "-"
        fi
    done

    echo ""
    echo "Last-month daily downloads grouped into 7-day buckets:"
    if range_json="$(curl -fsSL "https://api.npmjs.org/downloads/range/last-month/${encoded}" 2>/dev/null)"; then
        jq -r '.downloads[] | [.day, .downloads] | @tsv' <<<"$range_json" |
            awk 'BEGIN { sum = 0; start = "" } { if (start == "") start = $1; sum += $2; if (NR % 7 == 0) { printf "%s to %s\t%d\n", start, $1, sum; sum = 0; start = "" } } END { if (start != "") printf "%s to %s\t%d\n", start, $1, sum }'
    else
        echo "unavailable"
    fi

# Show GitHub repository and release asset metrics
[no-cd]
github repo=github_repo:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v gh >/dev/null || { echo "gh is required" >&2; exit 1; }
    command -v jq >/dev/null || { echo "jq is required" >&2; exit 1; }

    repo="{{repo}}"
    echo "GitHub repo: ${repo}"
    gh repo view "$repo" --json nameWithOwner,stargazerCount,forkCount,watchers,pushedAt,url |
        jq -r '
            "url: " + .url,
            "stars: " + (.stargazerCount | tostring),
            "forks: " + (.forkCount | tostring),
            "watchers: " + (.watchers.totalCount | tostring),
            "pushed_at: " + .pushedAt
        '

    releases="$(gh api "repos/${repo}/releases")"
    total="$(jq '[.[] | .assets[]? | .download_count] | add // 0' <<<"$releases")"
    macos="$(jq '[.[] | .assets[]? | select(.name | test("macOS-all\\.tar\\.gz$")) | .download_count] | add // 0' <<<"$releases")"
    echo "release_asset_downloads: ${total}"
    echo "macos_archive_downloads: ${macos}"
