import { expect, test } from 'claude-code/testing'

import { bandOf, coalesce, currentRow, progressOf, rowsOf, windowStart } from './fest'
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

test('the current row is the first unfinished task, not an unfinished ancestor', () => {
  const rows = rowsOf(SHOW.view.tree)
  expect(rows[currentRow(rows)]!.text).toBe('[ ] 01_todo_model')
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
