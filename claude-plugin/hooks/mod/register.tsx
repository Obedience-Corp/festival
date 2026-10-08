import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'
import type { FestView } from '../../types/index'

import { campRoot, festivalRoot, rootedPath } from './camp'
import { LEGACY_PROGRESS_FILES, READ_ONLY_FEST, STATUS_COLOR, bandOf, coalesce, currentRow, headerOf, rowsOfView, versionAtLeast, viewOf, windowStart } from './fest'

const PANE = 'fest-watch'
const band = atom({ plugin: 'festival', key: 'band' } as const, null)
const view = atom({ plugin: 'festival', key: 'view' } as const, null)
const isOpen = atom({ plugin: 'festival', key: 'isOpen' } as const, false)
const notice = atom({ plugin: 'festival', key: 'notice' } as const, null)

const COMMANDS = [
  { name: 'fest-watch', description: 'Toggle the live Festival pane' },
  { name: 'fest-task', description: 'Print the current task (fest next)', immediate: true },
  { name: 'fest-progress', description: 'Print festival progress (fest progress)', immediate: true },
] as const

let timer: { cancel: () => void } | null = null
let watchGeneration = 0
const runRefresh = coalesce()
let wantsTakeover = false
let showIsReadOnly: boolean | null = null

const PLAN_DENY =
  'This camp plans with Festival, so plan mode is off here. Do not retry it. Size the work as one session, a standalone workflow (`fest create workflow`), or a festival, then run `fest next` and follow what it prints.'
const TODO_DENY =
  'This camp tracks tasks with Festival, not a session todo list. Run `fest next` for the current task and `fest task completed` when it is done.'

async function runJson($: any, argv: string[], cwd?: string) {
  try {
    const r = await $.process.run(argv, cwd ? { timeoutMs: 5000, cwd } : { timeoutMs: 5000 })
    if (r.exitCode !== 0 || r.isStdoutTruncated) return null
    return JSON.parse(r.stdout)
  } catch {
    return null
  }
}

async function festShowIsReadOnly($: any): Promise<boolean | null> {
  try {
    const r = await $.process.run(['fest', 'version', '--short'], { timeoutMs: 5000 })
    return r.exitCode === 0 ? versionAtLeast(r.stdout, READ_ONLY_FEST) : null
  } catch {
    return null
  }
}

const NEEDS_NEWER_FEST = `This view needs fest ${READ_ONLY_FEST} or newer here.`
const FEST_UNAVAILABLE = 'fest did not answer `fest version --short`; is it installed?'

type PollPlan = { blocker: string | null; cwd?: string }

async function pollPlan($: any): Promise<PollPlan> {
  if (showIsReadOnly === null) showIsReadOnly = await festShowIsReadOnly($)
  if (showIsReadOnly === true) return { blocker: null }
  if (showIsReadOnly === null) return { blocker: FEST_UNAVAILABLE }
  try {
    const exists = (p: string) => $.fs.exists(p)
    const cwd = await $.session.cwd()
    const root = await festivalRoot(exists, cwd)
    if (root === null) return { blocker: NEEDS_NEWER_FEST }
    for (const file of LEGACY_PROGRESS_FILES) {
      if (await exists(`${root}/.fest/${file}`)) return { blocker: NEEDS_NEWER_FEST }
    }
    return { blocker: null, cwd }
  } catch {
    return { blocker: NEEDS_NEWER_FEST }
  }
}

async function refresh($: any) {
  if ((await $.session.surfaces()).length === 0) return
  const { blocker, cwd } = await pollPlan($)
  if (blocker !== null) {
    await update($, view, () => null)
    await update($, band, () => null)
    await update($, notice, () => blocker)
    $.ui.invalidate('ui.render')
    return
  }
  let next: FestView | null = null
  let text: string | null = null
  try {
    next = viewOf(await runJson($, ['fest', 'show', '--json'], cwd))
    text = bandOf(next)
    if (next) rowsOfView(next)
  } catch {
    next = null
    text = null
  }
  await update($, notice, () => null)
  await update($, view, () => next)
  await update($, band, () => text)
  $.ui.invalidate('ui.render')
}

function scheduleRefresh($: any): Promise<void> {
  return runRefresh(() => refresh($))
}

async function refreshOwnOrSkip($: any): Promise<void> {
  if (runRefresh.isBusy()) {
    void scheduleRefresh($)
    return
  }
  await scheduleRefresh($)
}

function startPolling($: any, generation: number) {
  if (generation !== watchGeneration) return
  timer?.cancel()
  timer = $.clock.every(5000, () => void scheduleRefresh($))
}

async function takeoverActive($: any): Promise<boolean> {
  if (!wantsTakeover) return false
  try {
    return (await campRoot(p => $.fs.exists(p), await $.session.cwd())) !== null
  } catch {
    return false
  }
}

async function stopWatching($: any) {
  watchGeneration += 1
  timer?.cancel()
  timer = null
  await update($, isOpen, () => false)
}

async function plain($: any, argv: string[]) {
  try {
    const r = await $.process.run(argv, { timeoutMs: 10000 })
    return (r.stdout || r.stderr).trimEnd() || `(${argv.join(' ')} printed nothing, exit ${r.exitCode})`
  } catch (err) {
    return `${argv.join(' ')} failed: ${String(err)}`
  }
}

export const register: Register = (on, options) => {
  wantsTakeover = (options as { planningTakeover?: boolean } | undefined)?.planningTakeover === true

  on('session.start', async ($, e, next) => {
    for (const spec of COMMANDS) {
      try {
        await $.command.register(spec)
      } catch {}
    }
    try {
      const panes = await $.ui.panes()
      if (!panes.some((p: { id: string }) => p.id === PANE)) await stopWatching($)
      else await update($, isOpen, () => true)
    } catch {
      await stopWatching($)
    }
    const generation = watchGeneration
    await refreshOwnOrSkip($)
    if (await read($, isOpen)) startPolling($, generation)
    return next(e)
  }).catch(($, e, next) => next(e))

  on('turn.complete', async ($, e, next) => {
    const done = await next(e)
    $.clock.after(0, () => void scheduleRefresh($))
    return done
  }).catch(($, e, next) => next(e))

  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    const ran = await next(e)
    if (/\b(fest|camp) /.test(e.command)) $.clock.after(0, () => void scheduleRefresh($))
    return ran
  }).catch(($, e, next) => next(e))

  on('agent.offer', async ($, e, next) =>
    e.agent === 'Plan' && (await takeoverActive($)) ? { isOffered: false } : next(e),
  ).catch(($, e, next) => next(e))

  on('tool.call', { tool: 'EnterPlanMode' }, async ($, e, next) =>
    (await takeoverActive($)) ? { deny: PLAN_DENY } : next(e),
  ).catch(($, e, next) => next(e))
  on('tool.call', { tool: ['TodoWrite', 'TaskCreate'] }, async ($, e, next) =>
    (await takeoverActive($)) ? { deny: TODO_DENY } : next(e),
  ).catch(($, e, next) => next(e))
  on('prompt.attachment', { type: ['todo_reminder', 'task_reminder'] }, async ($, e, next) =>
    (await takeoverActive($)) ? { text: null } : next(e),
  ).catch(($, e, next) => next(e))

  on('classic.CwdChanged', async ($, e, next) => {
    const done = await next(e)
    $.ui.invalidate('prompt.attachment')
    $.clock.after(0, () => void scheduleRefresh($))
    return done
  }).catch(($, e, next) => next(e))

  on('command.run', { command: 'fest-task' }, async $ => ({ text: await plain($, ['fest', 'next']) }))
    .catch(() => ({ text: 'fest-task failed; run `fest next` in a terminal.' }))
  on('command.run', { command: 'fest-progress' }, async $ => ({ text: await plain($, ['fest', 'progress']) }))
    .catch(() => ({ text: 'fest-progress failed; run `fest progress` in a terminal.' }))

  on('command.run', { command: 'fest-watch' }, async $ => {
    if (await read($, isOpen)) {
      await stopWatching($)
      await $.ui.close({ id: PANE })
      return { text: 'Festival pane closed.' }
    }
    if ((await $.session.surfaces()).length === 0) {
      return { text: 'The Festival pane needs an interactive Claude Code session.' }
    }
    await $.ui.open({ id: PANE, title: 'Festival' })
    await update($, isOpen, () => true)
    const generation = watchGeneration
    await refreshOwnOrSkip($)
    if (!(await read($, isOpen)) || generation !== watchGeneration) return { text: 'Festival pane closed.' }
    startPolling($, generation)
    return { text: 'Festival pane opened.' }
  }).catch(() => ({ text: 'The Festival pane could not be toggled.' }))

  on('ui.close', async ($, e, next) => {
    if (e.id === PANE) await stopWatching($)
    return next(e)
  }).catch(($, e, next) => next(e))

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const text = await read($, band)
    if (!text || e.props.hasSurvey) return next(e)
    const { Box, Text } = $.ui.resolve(e)
    const [head, ...rest] = text.split(' | ')
    const tail = rest.length > 1 ? rest.pop() : undefined
    return (
      <Box>
        <Text>
          <Text color="claude" bold>{head}</Text>
          {rest.map(part => <Text dimColor>{' | '}{part}</Text>)}
          {tail ? <Text color="success">{' | '}{tail}</Text> : null}
        </Text>
      </Box>
    )
  })

  on('ui.render', { component: 'Pane', requestId: PANE }, async ($, e) => {
    const { Box, Text } = $.ui.resolve(e)
    const data = await read($, view)
    if (!data) return <Text dimColor>{(await read($, notice)) ?? 'No festival or workflow here.'}</Text>
    const body = e.props.scroll?.bodyRows ?? (e.viewport?.rows ?? 24) - 6
    const room = Math.max(3, body - 1)
    const rows = rowsOfView(data)
    const cur = currentRow(rows)
    const start = windowStart(rows, room)
    return (
      <Box flexDirection="column">
        <Text color="claude" bold>{headerOf(data)}</Text>
        {rows.slice(start, start + room).map((r, i) => (
          <Text color={STATUS_COLOR[r.status] ?? 'text'} bold={start + i === cur || r.status === 'in_progress'}>
            {'  '.repeat(r.depth)}{r.text}
          </Text>
        ))}
      </Box>
    )
  })

  on('prompt.mention', async ($, e, next) => {
    if (await $.fs.exists(e.path)) return next(e)
    const path = await rootedPath(p => $.fs.exists(p), await $.session.cwd(), e.mention)
    return path === null ? next(e) : next({ ...e, path })
  }).catch(($, e, next) => next(e))
}
