#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
camp_bin="${CAMP_BIN:-$repo_root/camp/bin/camp}"
fest_bin="${FEST_BIN:-$repo_root/fest/bin/fest}"
festival_name="${FESTIVAL_NAME:-beginner-path-smoke}"
keep_workdir="${KEEP_SMOKE_WORKDIR:-0}"
fest_next_timeout_seconds="${FEST_NEXT_TIMEOUT_SECONDS:-30}"

step="startup"
tmp_root=""
campaign_dir=""
log_dir=""

cleanup() {
    local exit_code=$?

    if [[ -z "$tmp_root" ]]; then
        return
    fi

    if [[ $exit_code -ne 0 ]]; then
        echo >&2
        echo "beginner-path smoke failed at step: $step" >&2
        echo "workspace: $tmp_root" >&2
        echo "campaign: $campaign_dir" >&2
        echo "logs: $log_dir" >&2
        return
    fi

    if [[ "$keep_workdir" == "1" ]]; then
        echo
        echo "beginner-path smoke passed; preserved workspace: $tmp_root"
        return
    fi

    rm -rf "$tmp_root"
}
trap cleanup EXIT

escape_marker_value() {
    local value="$1"
    value=${value//\\/\\\\}
    value=${value//\"/\\\"}
    value=${value//$'\n'/\\n}
    value=${value//$'\r'/\\r}
    value=${value//$'\t'/\\t}
    printf '%s' "$value"
}

marker_value() {
    local hint="$1"
    local index="$2"

    case "$hint" in
        "What exists today and what problems it creates")
            printf 'A first-time user needs one verified path from install to first fest next.'
            ;;
        "What we want to achieve")
            printf 'Prove the canonical beginner path works without confusion.'
            ;;
        "Impact of solving this problem")
            printf 'Launch confidence improves because the path is smoke-tested.'
            ;;
        "What's included in this festival")
            printf 'Verify install, init, project add, festival creation, validate, and fest next.'
            ;;
        "What's explicitly NOT included")
            printf 'No advanced extensibility or optional branches.'
            ;;
        "First phase name"|"Phase name like 001_INGEST"|"Phase Name")
            printf '001_INGEST'
            ;;
        "Phase name like 001_PLANNING")
            printf '002_PLAN'
            ;;
        "Brief description of what this phase accomplishes")
            printf 'Turn raw beginner-path inputs into structured, executable planning.'
            ;;
        "One sentence describing what this festival accomplishes")
            printf 'Verify a new user can reach first fest next on the standard path.'
            ;;
        "2-3 sentences describing the desired end state")
            printf 'A temp campaign can be initialized, given one local project, and used to create a valid standard festival. The first fest next should enter 001_INGEST instead of failing on markers or validation.'
            ;;
        "Specific functional outcome")
            printf 'The smoke path passes end to end.'
            ;;
        "Quality standard with metric")
            printf 'The smoke script exits 0 and prints the 001_INGEST workflow step.'
            ;;
        "Phase name")
            printf '001_INGEST'
            ;;
        "Brief description")
            printf 'Capture and structure the work before implementation.'
            ;;
        "Additional completion criterion")
            printf 'Validation passes before the first fest next.'
            ;;
        "Primary objective in one clear sentence")
            printf 'Verify the beginner launch path in a temp workspace.'
            ;;
        "Planning/Active/Review/Complete")
            printf 'Planning'
            ;;
        "First phase name and brief description")
            printf '001_INGEST - capture requirements and constraints'
            ;;
        "Sequence names or N/A for planning phases")
            printf 'N/A'
            ;;
        "List blockers or None")
            printf 'None'
            ;;
        "Not Started/In Progress/Completed/Blocked")
            printf 'Not Started'
            ;;
        "First sequence name")
            printf '01_capture_requirements'
            ;;
        "Where the input came from and how the structured output will be used")
            printf 'Input comes from launch-path requirements and produces planning-ready outputs.'
            ;;
        "Input source 1 - e.g., user requirements document")
            printf 'Launch path requirements'
            ;;
        "Input source 2 - e.g., reference materials")
            printf 'Current beginner docs'
            ;;
        "Additional sources as needed")
            printf 'CLI command behavior'
            ;;
        "Topic or area to investigate")
            printf 'Beginner-path validation scope'
            ;;
        "Critical question that needs resolution")
            printf 'Does the first fest next reach ingest cleanly?'
            ;;
        "Document name and purpose")
            printf 'Implementation plan and task breakdown'
            ;;
        "Key planning outcome achieved")
            printf 'Executable tasks created for launch verification'
            ;;
        "Any assumptions, constraints, or open questions")
            printf 'Use the standard beginner path and keep the scope narrow.'
            ;;
        *)
            printf 'Smoke value %s' "$index"
            ;;
    esac
}

require_executable() {
    local label="$1"
    local path="$2"

    if [[ -x "$path" ]]; then
        return
    fi

    echo "$label binary not found or not executable: $path" >&2
    echo "Build repo-local binaries first with 'just build all', or override $label with CAMP_BIN/FEST_BIN." >&2
    exit 1
}

run_step_quiet() {
    local step_name="$1"
    shift

    step="$step_name"
    local log_file="$log_dir/${step_name}.log"

    echo
    echo "==> [$step_name]"

    if ! "$@" >"$log_file" 2>&1; then
        cat "$log_file" >&2
        echo "step failed: $step_name" >&2
        echo "log: $log_file" >&2
        return 1
    fi

    echo "ok"
}

run_step() {
    local step_name="$1"
    shift

    step="$step_name"
    local log_file="$log_dir/${step_name}.log"

    echo
    echo "==> [$step_name]"

    if ! "$@" > >(tee "$log_file") 2> >(tee -a "$log_file" >&2); then
        echo "step failed: $step_name" >&2
        echo "log: $log_file" >&2
        return 1
    fi
}

run_step_capture_stdout_quiet() {
    local step_name="$1"
    local stdout_file="$2"
    shift 2

    step="$step_name"
    local log_file="$log_dir/${step_name}.log"

    echo
    echo "==> [$step_name]"

    if ! "$@" >"$stdout_file" 2>"$log_file"; then
        [[ -s "$stdout_file" ]] && cat "$stdout_file" >&2
        [[ -s "$log_file" ]] && cat "$log_file" >&2
        echo "step failed: $step_name" >&2
        echo "log: $log_file" >&2
        return 1
    fi

    cat "$stdout_file" >>"$log_file"
    echo "ok"
}

run_step_capture_stdout() {
    local step_name="$1"
    local stdout_file="$2"
    shift 2

    step="$step_name"
    local log_file="$log_dir/${step_name}.log"

    echo
    echo "==> [$step_name]"

    if ! "$@" > >(tee "$stdout_file" "$log_file") 2> >(tee -a "$log_file" >&2); then
        echo "step failed: $step_name" >&2
        echo "log: $log_file" >&2
        return 1
    fi
}

run_step_capture_stdout_with_timeout() {
    local step_name="$1"
    local stdout_file="$2"
    local timeout_seconds="$3"
    shift 3

    step="$step_name"
    local log_file="$log_dir/${step_name}.log"
    local timeout_bin=""

    if command -v timeout >/dev/null 2>&1; then
        timeout_bin="timeout"
    elif command -v gtimeout >/dev/null 2>&1; then
        timeout_bin="gtimeout"
    fi

    echo
    echo "==> [$step_name]"

    if [[ -n "$timeout_bin" ]]; then
        if ! "$timeout_bin" "$timeout_seconds" "$@" > >(tee "$stdout_file" "$log_file") 2> >(tee -a "$log_file" >&2); then
            echo "step failed: $step_name" >&2
            echo "log: $log_file" >&2
            return 1
        fi
        return
    fi

    "$@" > >(tee "$stdout_file" "$log_file") 2> >(tee -a "$log_file" >&2) &
    local command_pid=$!
    (
        sleep "$timeout_seconds"
        if kill -0 "$command_pid" 2>/dev/null; then
            echo "step timed out after ${timeout_seconds}s: $step_name" | tee -a "$log_file" >&2
            kill -TERM "$command_pid" 2>/dev/null || true
            sleep 2
            kill -KILL "$command_pid" 2>/dev/null || true
        fi
    ) &
    local watchdog_pid=$!

    if ! wait "$command_pid"; then
        kill "$watchdog_pid" 2>/dev/null || true
        wait "$watchdog_pid" 2>/dev/null || true
        echo "step failed: $step_name" >&2
        echo "log: $log_file" >&2
        return 1
    fi

    kill "$watchdog_pid" 2>/dev/null || true
    wait "$watchdog_pid" 2>/dev/null || true
}

write_markers_file() {
    local dryrun_json="$1"
    local markers_json="$2"
    local count=0
    local first=1

    step="write-markers-file"
    echo
    echo "==> [write-markers-file]"

    {
        printf '{\n'

        while IFS= read -r hint; do
            [[ -z "$hint" ]] && continue

            local value
            value="$(marker_value "$hint" "$((count + 1))")"

            if [[ $first -eq 0 ]]; then
                printf ',\n'
            fi

            printf '  "%s": "%s"' "$(escape_marker_value "$hint")" "$(escape_marker_value "$value")"

            first=0
            count=$((count + 1))
        done < <(awk -F'"' '/"hint": / {print $4}' "$dryrun_json")

        printf '\n}\n'
    } > "$markers_json"

    if [[ $count -eq 0 ]]; then
        echo "No REPLACE markers were discovered in dry-run output." >&2
        return 1
    fi

    echo "Wrote $count marker values to $markers_json"
}

assert_fest_next_reaches_ingest() {
    local next_output_file="$1"

    step="assert-fest-next"
    echo
    echo "==> [assert-fest-next]"

    if ! grep -q 'WORKFLOW PHASE' "$next_output_file"; then
        echo "Expected fest next to return a workflow step, not an implementation task." >&2
        return 1
    fi

    if ! grep -q 'Phase: 001_INGEST' "$next_output_file"; then
        echo "Expected fest next to reach the 001_INGEST workflow." >&2
        return 1
    fi

    echo "fest next reached the 001_INGEST workflow successfully."
}

tmp_root="$(mktemp -d /tmp/festival-beginner-smoke-XXXXXX)"
campaign_dir="$tmp_root/campaign"
log_dir="$tmp_root/logs"
mkdir -p "$log_dir"

source_repo="$tmp_root/source-repo"
dryrun_json="$tmp_root/festival-dry-run.json"
markers_json="$tmp_root/markers.json"
next_output_file="$tmp_root/fest-next.out"
planning_dir=""
precreate_listing="$tmp_root/precreate-dirs.txt"

step="install-surface"
echo "workspace: $tmp_root"
require_executable "CAMP_BIN" "$camp_bin"
require_executable "FEST_BIN" "$fest_bin"

# Make the repo-local binaries discoverable to commands like `camp init`
# that shell out to sibling tools via PATH.
export PATH
PATH="$(dirname "$camp_bin"):$(dirname "$fest_bin"):$PATH"

run_step_quiet "init-local-source-repo" bash -c "
    set -euo pipefail
    mkdir -p '$source_repo'
    cd '$source_repo'
    git init >/dev/null
    git config user.name 'Smoke Test'
    git config user.email 'smoke@example.com'
    printf 'hello\n' > README.md
    git add README.md
    git commit -m 'initial commit for smoke path' >/dev/null
"

run_step_quiet "camp-init" "$camp_bin" init \
    --no-register \
    --yes \
    --description "smoke campaign" \
    --mission "verify beginner path" \
    "$campaign_dir"

run_step_quiet "campaign-git-config" git -C "$campaign_dir" config user.name "Smoke Test"
run_step_quiet "campaign-git-email" git -C "$campaign_dir" config user.email "smoke@example.com"

run_step_quiet "project-add-local" bash -c "
    set -euo pipefail
    cd '$campaign_dir'
    '$camp_bin' project add '$source_repo' --local '$source_repo' --name sample
"

run_step_capture_stdout_quiet "festival-dry-run" "$dryrun_json" bash -c "
    set -euo pipefail
    cd '$campaign_dir'
    CAMP_ROOT='$campaign_dir' '$fest_bin' create festival --name '$festival_name' --type standard --dry-run --json
"

write_markers_file "$dryrun_json" "$markers_json"

planning_dir="$campaign_dir/festivals/planning"
find "$planning_dir" -maxdepth 1 -type d -name "${festival_name}-*" | sort >"$precreate_listing"

run_step_quiet "festival-create" bash -c "
    set -euo pipefail
    cd '$campaign_dir'
    CAMP_ROOT='$campaign_dir' '$fest_bin' create festival --name '$festival_name' --type standard --markers-file '$markers_json'
"

festival_dir="$(
    comm -13 \
        <(sort "$precreate_listing") \
        <(find "$planning_dir" -maxdepth 1 -type d -name "${festival_name}-*" | sort) \
        | head -n 1
)"
if [[ -z "$festival_dir" ]]; then
    step="locate-created-festival"
    echo "Could not find the new festival directory created for $festival_name" >&2
    exit 1
fi

run_step_quiet "festival-validate" bash -c "
    set -euo pipefail
    cd '$festival_dir'
    CAMP_ROOT='$campaign_dir' '$fest_bin' validate
"

run_step_capture_stdout_with_timeout "festival-next" "$next_output_file" "$fest_next_timeout_seconds" bash -c "
    set -euo pipefail
    cd '$festival_dir'
    CAMP_ROOT='$campaign_dir' '$fest_bin' next
"

assert_fest_next_reaches_ingest "$next_output_file"

echo
echo "beginner-path smoke passed"
echo "festival directory: $festival_dir"
