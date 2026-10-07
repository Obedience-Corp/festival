import { expect, test } from 'claude-code/testing'

import { SHOW } from './fixtures'

const SESSION = { surface: 'terminal', isInteractive: true, cwd: '/work' } as const
const BAND = {
  component: 'AbovePrompt',
  surface: 'terminal',
  requestId: 'band',
  viewport: { columns: 120, rows: 30 },
  props: { hasSurvey: false, isWorking: false, maxRows: 3, bodyColumns: 118, scroll: { offset: 0, bodyRows: 3 } },
} as const

const SHOW_JSON = JSON.stringify(SHOW)
const BAND_TEXT = 'build-todo-app-BT0001 | 003_IMPLEMENT > 01_app_core > 01_todo_model | 19/35 (54%)'

const textOf = (t: unknown): string =>
  typeof t === 'string' || typeof t === 'number'
    ? String(t)
    : Array.isArray(t)
      ? t.map(textOf).join('')
      : t && typeof t === 'object'
        ? textOf(Reflect.get(t, 'children') ?? [])
        : ''

const world = (on: any, surfaces: string[], cwd = '/work') => {
  on('session.start', () => ({ cwd }))
  on('session.surfaces', () => ({ value: surfaces }))
  on('session.cwd', () => ({ value: cwd }))
  on('command.register', () => ({ value: undefined }))
}

const run = (command: string) => ({ command, args: '', origin: { kind: 'user' } as any, presentation: {} as any })

const ok = (stdout: string) => ({ exitCode: 0, stdout, stderr: '', isStdoutTruncated: false, isStderrTruncated: false })

test('band draws from fest show json and polling never runs fest next', async ($, on) => {
  world(on, ['terminal'])
  on('fs.exists', () => ({ value: false }))
  const ran: string[][] = []
  on('process.run', (_$, e: any) => { ran.push(e.argv); return { value: ok(SHOW_JSON) } })
  on('ui.open', () => ({ value: { isPlaced: true } }) as any)
  on('clock.every', () => ({ value: undefined }) as any)
  on('clock.after', () => ({ value: undefined }) as any)
  await $.session.start(SESSION)
  expect(textOf(await $.ui.render(BAND as any))).toContain(BAND_TEXT)
  await $.command.run(run('fest-watch') as any)
  expect(ran.length).toBeGreaterThan(0)
  expect(ran.every(argv => argv.join(' ') === 'fest show --json')).toBe(true)
})

test('band draws nothing when fest exits nonzero', async ($, on) => {
  world(on, ['terminal'])
  on('fs.exists', () => ({ value: false }))
  on('process.run', () => ({ value: { ...ok(''), exitCode: 1, stderr: 'boom' } }))
  on('ui.render', ($, e: any) => $.ui.resolve(e).Text({ children: 'ENGINE-OWN' }) as any)
  await $.session.start(SESSION)
  const drawn = await $.ui.render(BAND as any)
  expect(textOf(drawn)).toBe('ENGINE-OWN')
})

const tool = (name: string) => ({ tool: name, origin: { kind: 'user' } as any })

test('/fest-task returns the stubbed fest next text', async ($, on) => {
  world(on, [])
  on('fs.exists', () => ({ value: false }))
  on('process.run', () => ({ value: ok('NEXT TASK: do the thing\n') }))
  await $.session.start(SESSION)
  const out = await $.command.run(run('fest-task'))
  expect(out.text).toBe('NEXT TASK: do the thing')
})

test('/fest-progress returns the stubbed fest progress text', async ($, on) => {
  world(on, [])
  on('fs.exists', () => ({ value: false }))
  let argv: string[] = []
  on('process.run', (_$, e: any) => { argv = e.argv; return { value: ok('tasks 19/103 (18%)\n') } })
  await $.session.start(SESSION)
  const out = await $.command.run(run('fest-progress'))
  expect(out.text).toBe('tasks 19/103 (18%)')
  expect(argv).toEqual(['fest', 'progress'])
})

test('/fest-task reports a missing fest instead of throwing', async ($, on) => {
  world(on, [])
  on('fs.exists', () => ({ value: false }))
  on('process.run', () => { throw new Error('ENOENT') })
  await $.session.start(SESSION)
  const out = await $.command.run(run('fest-task'))
  expect(out.text).toContain('fest next failed')
})

const FILES = new Set(['/camp/.campaign', '/camp/notes/a.md'])

test('mention falls back to the camp root when the local path is missing', async ($, on) => {
  world(on, [], '/camp/projects/demo')
  on('fs.exists', (_$, e: any) => ({ value: FILES.has(e.path) }) as any)
  let seen = ''
  on('prompt.mention', (_$, e) => { seen = e.path; return { type: 'file' } })
  await $.session.start({ ...SESSION, cwd: '/camp/projects/demo' })
  await $.prompt.mention({ mention: 'notes/a.md#L1-2', path: '/camp/projects/demo/notes/a.md' })
  expect(seen).toBe('/camp/notes/a.md')
})

test('mention passes through when the local path exists', async ($, on) => {
  on('fs.exists', (_$, e: any) => ({ value: e.path === '/camp/projects/demo/x.md' || FILES.has(e.path) }) as any)
  let seen = ''
  on('prompt.mention', (_$, e) => { seen = e.path; return { type: 'file' } })
  await $.prompt.mention({ mention: 'x.md', path: '/camp/projects/demo/x.md' })
  expect(seen).toBe('/camp/projects/demo/x.md')
})

test('mention passes through unchanged when the camp lookup throws', async ($, on) => {
  world(on, [], '/camp/projects/demo')
  on('fs.exists', () => { throw new Error('disk gone') })
  let seen = ''
  on('prompt.mention', (_$, e) => { seen = e.path; return { type: 'file' } })
  await $.session.start({ ...SESSION, cwd: '/camp/projects/demo' })
  const path = '/camp/projects/demo/notes/a.md'
  await $.prompt.mention({ mention: 'notes/a.md', path })
  expect(seen).toBe(path)
})

const inCamp = (on: any) => {
  world(on, [], '/camp/projects/demo')
  on('fs.exists', (_$: any, e: any) => ({ value: e.path === '/camp/.campaign' }) as any)
  on('tool.call', () => ({ result: 'entered' }) as any)
}
const START = { ...SESSION, cwd: '/camp/projects/demo' }

test('takeover denies plan mode and todo tools inside a camp', { options: { planningTakeover: true } }, async ($, on) => {
  inCamp(on)
  await $.session.start(START)
  const plan: any = await $.tool.call(tool('EnterPlanMode') as any)
  expect(String(plan.deny)).toContain('plans with Festival')
  const todo: any = await $.tool.call(tool('TodoWrite') as any)
  expect(String(todo.deny)).toContain('tracks tasks with Festival')
  const task: any = await $.tool.call(tool('TaskCreate') as any)
  expect(String(task.deny)).toContain('tracks tasks with Festival')
})

test('takeover is inert outside a camp even when enabled', { options: { planningTakeover: true } }, async ($, on) => {
  world(on, [], '/work')
  on('fs.exists', () => ({ value: false }))
  on('tool.call', () => ({ result: 'entered' }) as any)
  await $.session.start(SESSION)
  const out: any = await $.tool.call(tool('EnterPlanMode') as any)
  expect(out.result).toBe('entered')
})

test('takeover stays off by default inside a camp', async ($, on) => {
  inCamp(on)
  await $.session.start(START)
  const out: any = await $.tool.call(tool('EnterPlanMode') as any)
  expect(out.result).toBe('entered')
})

test('a failed camp lookup at startup still draws the band and leaves takeover off', { options: { planningTakeover: true } }, async ($, on) => {
  on('session.start', () => ({ cwd: '/camp/projects/demo' }))
  on('session.surfaces', () => ({ value: ['terminal'] }))
  on('session.cwd', () => { throw new Error('cwd unavailable') })
  on('command.register', () => ({ value: undefined }) as any)
  on('fs.exists', () => ({ value: false }))
  on('process.run', () => ({ value: ok(SHOW_JSON) }))
  on('tool.call', () => ({ result: 'entered' }) as any)
  await $.session.start(START)
  expect(textOf(await $.ui.render(BAND as any))).toContain('19/35 (54%)')
  const out: any = await $.tool.call(tool('EnterPlanMode') as any)
  expect(out.result).toBe('entered')
})

test('the pane opens again after the command closed it', async ($, on) => {
  world(on, ['terminal'])
  on('fs.exists', () => ({ value: false }) as any)
  on('process.run', () => ({ value: ok(SHOW_JSON) }) as any)
  on('ui.open', () => ({ value: { isPlaced: true } }) as any)
  on('ui.close', () => ({ value: undefined }) as any)
  let timers = 0
  on('clock.every', (() => { timers += 1; return { value: undefined } }) as any)
  await $.session.start(SESSION)
  const texts: string[] = []
  for (let i = 0; i < 3; i++) texts.push(((await $.command.run(run('fest-watch') as any)) as any).text)
  expect(texts).toEqual(['Festival pane opened.', 'Festival pane closed.', 'Festival pane opened.'])
  expect(timers).toBe(2)
})

test('a pane that fails to open does not leave the module thinking it is open', async ($, on) => {
  world(on, ['terminal'])
  on('fs.exists', () => ({ value: false }) as any)
  on('process.run', () => ({ value: ok(SHOW_JSON) }) as any)
  let opens = 0
  on('ui.open', (() => { opens += 1; if (opens === 1) throw new Error('no room'); return { value: { isPlaced: true } } }) as any)
  on('clock.every', () => ({ value: undefined }) as any)
  await $.session.start(SESSION)
  const first: any = await $.command.run(run('fest-watch') as any)
  const second: any = await $.command.run(run('fest-watch') as any)
  expect(first.text).toBe('The Festival pane could not be toggled.')
  expect(second.text).toBe('Festival pane opened.')
})

test('the pane command does nothing in a session with no screen', async ($, on) => {
  world(on, [])
  on('fs.exists', () => ({ value: false }) as any)
  let opened = false
  on('ui.open', (() => { opened = true; return { value: { isPlaced: true } } }) as any)
  await $.session.start(SESSION)
  const out: any = await $.command.run(run('fest-watch') as any)
  expect(out.text).toContain('needs an interactive')
  expect(opened).toBe(false)
})

test('takeover also drops the task reminder', { options: { planningTakeover: true } }, async ($, on) => {
  inCamp(on)
  on('prompt.attachment', () => ({ text: 'engine reminder' }) as any)
  await $.session.start(START)
  const todo: any = await $.prompt.attachment({ type: 'todo_reminder', detail: {} } as any)
  const tasks: any = await $.prompt.attachment({ type: 'task_reminder', detail: {} } as any)
  expect(todo.text).toBeNull()
  expect(tasks.text).toBeNull()
})
