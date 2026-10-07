import { expect, test } from 'claude-code/testing'

import { rootedPath } from './camp'
import { bandOf, coalesce, currentRow, headerOf, rowsOf, rowsOfView, viewOf, windowStart } from './fest'
import { SHOW, SHOW_STANDALONE } from './fixtures'

const workflow = (steps: Array<[string, string]>, runStatus = 'active') =>
  viewOf({ ...SHOW_STANDALONE, run_status: runStatus, steps: steps.map(([name, status], i) => ({ number: i + 1, name, status })) })

test('the festival band names the current phase, sequence, and task from fest show', () => {
  expect(bandOf(viewOf(SHOW))).toBe('festival build-todo-app-BT0001 | 003_IMPLEMENT > 01_app_core > 01_todo_model | 19/35 (54%)')
})

test('a festival in a workflow phase shows the current step', () => {
  const tree = {
    name: 'ritual', status: 'in_progress', node_type: 'festival',
    children: [{ name: '001_DISCOVER', status: 'in_progress', node_type: 'phase', children: [
      { name: '01_inventory', status: 'completed', node_type: 'sequence' },
      { name: 'Step 1: SCOPE', status: 'in_progress', node_type: 'step' },
      { name: 'Step 2: DISCOVER', status: 'pending', node_type: 'step' },
    ] }],
  }
  const band = bandOf(viewOf({ name: 'ritual', view: { tree }, stats: { tasks: { total: 9, completed: 4 }, progress: 44 } }))
  expect(band).toBe('festival ritual | 001_DISCOVER > Step 1: SCOPE | 4/9 (44%)')
})

test('a festival is complete only when nothing is left', () => {
  const tree = { name: 'done', status: 'completed', node_type: 'festival', children: [{ name: '001_A', status: 'completed', node_type: 'phase' }] }
  expect(bandOf(viewOf({ view: { tree }, stats: { tasks: { total: 3, completed: 3 }, progress: 100 } }))).toBe('festival done | complete | 3/3 (100%)')
  const blocked = { name: 'stuck', status: 'blocked', node_type: 'festival', children: [{ name: '001_A', status: 'blocked', node_type: 'phase', children: [{ name: '01_wait.md', status: 'blocked', node_type: 'task' }] }] }
  expect(bandOf(viewOf({ view: { tree: blocked }, stats: { tasks: { total: 3, completed: 2 }, progress: 66 } }))).toBe('festival stuck | 001_A > 01_wait (blocked) | 2/3 (66%)')
})

test('standalone workflow bands cover active, blocked, complete, skipped, and no run', () => {
  expect(bandOf(viewOf(SHOW_STANDALONE))).toBe('workflow todo-sync-options | step 2/5: COMPARE | 1/5 steps')
  expect(bandOf(workflow([['A', 'completed'], ['B', 'blocked'], ['C', 'pending']]))).toBe('workflow todo-sync-options | step 2/3: B (blocked) | 1/3 steps')
  expect(bandOf(workflow([['A', 'completed'], ['B', 'completed']], 'completed'))).toBe('workflow todo-sync-options | complete | 2/2 steps')
  expect(bandOf(workflow([['A', 'skipped'], ['B', 'pending']]))).toBe('workflow todo-sync-options | step 2/2: B | 1/2 steps')
  expect(bandOf(workflow([]))).toBe('workflow todo-sync-options | no run')
})

test('viewOf rejects anything that is not a festival or standalone shape', () => {
  expect(viewOf(null)).toBeNull()
  expect(viewOf({ error: 'not in a festival directory or linked project' })).toBeNull()
  expect(bandOf(null)).toBeNull()
})

test('tree rows expand only the current branch', () => {
  const text = rowsOf(SHOW.view.tree).map(r => '  '.repeat(r.depth) + r.text).join('\n')
  expect(text).toContain('[x] 001_INGEST')
  expect(text).toContain('01_todo_model')
  expect(text).not.toContain('Step 1:')
})

const task = (name: string, status: string) => ({ name: `${name}.md`, status, node_type: 'task' })
const PARALLEL = {
  name: 'demo', status: 'in_progress', node_type: 'festival',
  children: [{ name: '001_BUILD', status: 'in_progress', node_type: 'phase', children: [
    { name: '01_api', status: 'pending', node_type: 'sequence', children: Array.from({ length: 12 }, (_, i) => task(`${String(i + 1).padStart(2, '0')}_api`, 'pending')) },
    { name: '02_ui', status: 'in_progress', node_type: 'sequence', children: [task('01_layout', 'completed'), task('02_forms', 'in_progress'), task('03_polish', 'pending')] },
  ] }],
}

test('the task being worked on wins over an earlier unfinished branch', () => {
  const rows = rowsOf(PARALLEL as any)
  expect(rows[currentRow(rows)]!.text).toBe('[~] 02_forms')
  const room = 5
  const start = windowStart(rows, room)
  expect(rows.slice(start, start + room).map(r => r.text)).toContain('[~] 02_forms')
})

test('the window keeps the current task visible past a long run of finished tasks', () => {
  const tasks = Array.from({ length: 40 }, (_, i) => task(`${String(i + 1).padStart(2, '0')}_task`, i < 25 ? 'completed' : 'pending'))
  const tree = { name: 'demo', status: 'in_progress', node_type: 'festival', children: [{ name: '001_BUILD', status: 'in_progress', node_type: 'phase', children: [{ name: '01_core', status: 'in_progress', node_type: 'sequence', children: tasks }] }] }
  const rows = rowsOf(tree as any)
  const room = 8
  const start = windowStart(rows, room)
  const visible = rows.slice(start, start + room).map(r => r.text)
  expect(visible.indexOf('[ ] 26_task')).toBe(Math.floor(room / 3))
})

test('the window starts at the top when everything fits, and headers count work', () => {
  const v = viewOf(SHOW)!
  expect(windowStart(rowsOfView(v), 500)).toBe(0)
  expect(headerOf(v)).toBe('tasks 19/35 (54%)')
  expect(headerOf(viewOf(SHOW_STANDALONE)!)).toBe('steps 1/5')
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
