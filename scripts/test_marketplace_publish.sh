#!/usr/bin/env bash
set -euo pipefail
# Run in the owning repo's disposable container lane: these tests exercise real
# git worktrees plus mocked GitHub boundaries, without credentials or network.
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s scripts -p 'test_reconcile_*.py' -v
