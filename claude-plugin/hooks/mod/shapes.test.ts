import { expect, test } from 'claude-code/testing'

import { bandOf, coalesce, currentRow, focusOf, progressOf, rowsOf, windowStart } from './fest'
import { NEXT_FESTIVAL, NEXT_STANDALONE, SHOW } from './fixtures'
import { rootedPath } from './camp'

test('bandOf handles the festival shape', () => {
  expect(bandOf(NEXT_FESTIVAL)).toBe(
    'festival build-todo-app-BT0001 | 003_IMPLEMENT > 01_app_core > 01_todo_model | 19/35 (54%)',
  )
})

test('bandOf handles the standalone shape', () => {
  expect(bandOf(NEXT_STANDALONE)).toBe(
    'workflow todo-sync-options | step 2/5: Compare storage backends',
  )
})

test('bandOf rejects junk', () => {
  expect(bandOf(null)).toBeNull()
  expect(bandOf({ error: 'x' })).toBeNull()
})

test('tree rows expand only the current branch', () => {
  const rows = rowsOf(SHOW.view.tree)
  const text = rows.map(r => '  '.repeat(r.depth) + r.text).join('\n')
  expect(rows[0]!.text).toContain('build-todo-app-BT0001')
  expect(text).toContain('[x] 001_INGEST')
  expect(text).toContain('01_todo_model')
  expect(text).not.toContain('Step 1:')
})

test('the current row is the task fest next names, not an unfinished ancestor', () => {
  const rows = rowsOf(SHOW.view.tree, focusOf(NEXT_FESTIVAL))
  expect(rows[currentRow(rows)]!.text).toBe('[ ] 01_todo_model')
  expect(rows[currentRow(rows)]!.isFocus).toBe(true)
})

const task = (name: string, status: string) => ({ name: `${name}.md`, status, node_type: 'task' })
const PARALLEL = {
  name: 'demo', status: 'in_progress', node_type: 'festival',
  children: [{ name: '001_BUILD', status: 'in_progress', node_type: 'phase', children: [
    { name: '01_api', status: 'pending', node_type: 'sequence', children: Array.from({ length: 12 }, (_, i) => task(`${String(i + 1).padStart(2, '0')}_api`, 'pending')) },
    { name: '02_ui', status: 'in_progress', node_type: 'sequence', children: [task('01_layout', 'completed'), task('02_forms', 'in_progress'), task('03_polish', 'pending')] },
  ] }],
}

test('with parallel sequences the window follows the task fest next names, in a later branch', () => {
  const focus = focusOf({ task: { name: '02_forms', phase_name: '001_BUILD', sequence_name: '02_ui' } })
  const rows = rowsOf(PARALLEL as any, focus)
  expect(rows.map(r => r.text)).toContain('[ ] 01_api')
  expect(rows.some(r => r.depth === 3 && r.text.includes('_api'))).toBe(false)
  const room = 5
  const start = windowStart(rows, room)
  expect(rows.slice(start, start + room).map(r => r.text)).toContain('[~] 02_forms')
})

test('without a focus an in-progress task wins over an earlier pending one', () => {
  const rows = rowsOf(PARALLEL as any)
  expect(rows[currentRow(rows)]!.text).toBe('[~] 02_forms')
})

test('focusOf needs the full phase, sequence, and task path and ignores .md', () => {
  expect(focusOf({ task: { name: '02_forms.md', phase_name: '001_BUILD', sequence_name: '02_ui' } })).toEqual(['001_BUILD', '02_ui', '02_forms'])
  expect(focusOf({ task: { name: '02_forms' } })).toBeNull()
  expect(focusOf({ festival_complete: true })).toBeNull()
})

test('the window keeps the current task visible past a long run of finished tasks', () => {
  const tasks = Array.from({ length: 40 }, (_, i) => ({
    name: `${String(i + 1).padStart(2, '0')}_task`,
    status: i < 25 ? 'completed' : 'pending',
    node_type: 'task',
  }))
  const tree = {
    name: 'demo', status: 'in_progress', node_type: 'festival',
    children: [{ name: '001_BUILD', status: 'in_progress', node_type: 'phase',
      children: [{ name: '01_core', status: 'in_progress', node_type: 'sequence', children: tasks }] }],
  }
  const rows = rowsOf(tree as any)
  const room = 8
  const start = windowStart(rows, room)
  const visible = rows.slice(start, start + room).map(r => r.text)
  expect(visible).toContain('[ ] 26_task')
  expect(visible.indexOf('[ ] 26_task')).toBe(Math.floor(room / 3))
})

test('the window starts at the top when everything fits', () => {
  const rows = rowsOf(SHOW.view.tree)
  expect(windowStart(rows, rows.length + 5)).toBe(0)
})

const tick = async () => {
  for (let i = 0; i < 10; i++) await Promise.resolve()
}

test('coalesce never runs two refreshes at once and keeps only the latest pending one', async () => {
  const schedule = coalesce()
  let running = 0
  let peak = 0
  const ran: string[] = []
  const gates: Array<() => void> = []
  const job = (name: string) => async () => {
    running += 1
    peak = Math.max(peak, running)
    await new Promise<void>(resolve => gates.push(resolve))
    ran.push(name)
    running -= 1
  }
  const first = schedule(job('a'))
  void schedule(job('b'))
  const last = schedule(job('c'))
  expect(last).toBe(first)
  while (gates.length) {
    gates.shift()!()
    await tick()
  }
  await last
  expect(peak).toBe(1)
  expect(ran).toEqual(['a', 'c'])
})

test('coalesce keeps going after a refresh throws', async () => {
  const schedule = coalesce()
  const ran: string[] = []
  const busy = schedule(async () => {
    await tick()
    throw new Error('fest hung')
  })
  void schedule(async () => { ran.push('next') })
  await busy
  await schedule(async () => { ran.push('after') })
  expect(ran).toEqual(['next', 'after'])
})

test('camp-root mentions never leave the camp', async () => {
  const files = new Set(['/camp/.campaign', '/camp/notes/a.md', '/etc/hosts'])
  const exists = async (p: string) => files.has(p)
  expect(await rootedPath(exists, '/camp/projects/demo', 'notes/a.md#L3')).toBe('/camp/notes/a.md')
  expect(await rootedPath(exists, '/camp/projects/demo', '../etc/hosts')).toBeNull()
  expect(await rootedPath(exists, '/camp/projects/demo', 'notes/../../etc/hosts')).toBeNull()
  expect(await rootedPath(exists, '/camp/projects/demo', '/etc/hosts')).toBeNull()
})

test('the band reports completion only when fest says the festival is complete', () => {
  const base = { location: { festival_path: '/camp/festivals/active/demo' }, progress: { completed_tasks: 4, total_tasks: 9, percentage: 44 } }
  const waiting = bandOf({ ...base, festival_complete: false, reason: 'No tasks are currently ready (dependencies not satisfied)' })!
  expect(waiting).not.toContain('complete |')
  expect(waiting).toContain('No tasks are currently ready')
  expect(waiting).toContain('4/9 (44%)')
  expect(bandOf({ ...base, festival_complete: true, progress: { completed_tasks: 9, total_tasks: 9, percentage: 100 } })).toBe('festival demo | complete | 9/9 (100%)')
  expect(bandOf({ ...base, festival_complete: false, planning: { phase_name: '001_INGEST' } })).toBe('festival demo | 001_INGEST (planning) | 4/9 (44%)')
  expect(bandOf({ location: base.location, festival_complete: false, festival_planning: { status: 'planning' } })).toBe('festival demo | planning')
})
