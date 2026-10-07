import { expect, test } from 'claude-code/testing'

import { bandOf, progressOf, rowsOf } from './fest'
import { NEXT_FESTIVAL, NEXT_STANDALONE, SHOW } from './fixtures'

test('bandOf handles the festival shape', () => {
  expect(bandOf(NEXT_FESTIVAL)).toBe(
    'festival festival-activity-in-festival-app-FA0031 | 003_ENGINE_SIDECAR > 01_engine_release > 01_baseline_and_worktree | 19/103 (18%)',
  )
})

test('bandOf handles the standalone shape', () => {
  expect(bandOf(NEXT_STANDALONE)).toBe(
    'workflow camp-dvc-support-2026-07-25 | step 2/7: Name the concrete payload',
  )
})

test('bandOf rejects junk', () => {
  expect(bandOf(null)).toBeNull()
  expect(bandOf({ error: 'x' })).toBeNull()
})

test('tree rows expand only the current branch', () => {
  const rows = rowsOf(SHOW.view.tree)
  const text = rows.map(r => '  '.repeat(r.depth) + r.text).join('\n')
  expect(rows[0]!.text).toContain('festival-activity-in-festival-app-FA0031')
  expect(text).toContain('[x] 001_INGEST')
  expect(text).toContain('01_baseline_and_worktree')
  expect(text).not.toContain('Step 1: READ')
})
