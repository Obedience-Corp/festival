import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import { rootedPath, campRoot } from './camp'
import { STATUS_COLOR, bandOf, coalesce, progressOf, rowsOf, windowStart } from './fest'

const PANE = 'fest-watch'
const band = atom({ plugin: 'festival', key: 'band' } as const, null)
const show = atom({ plugin: 'festival', key: 'show' } as const, null)
const isOpen = atom({ plugin: 'festival', key: 'isOpen' } as const, false)

const COMMANDS = [
  { name: 'fest-watch', description: 'Toggle the live Festival pane' },
  { name: 'fest-task', description: 'Print the current task (fest next)', immediate: true },
  { name: 'fest-progress', description: 'Print festival progress (fest progress)', immediate: true },
] as const

let timer: { cancel: () => void } | null = null
const runRefresh = coalesce()
let isTakeover = false

const PLAN_DENY =
  'This camp plans with Festival, so plan mode is off here. Do not retry it. Size the work as one session, a standalone workflow (`fest create workflow`), or a festival, then run `fest next` and follow what it prints.'
const TODO_DENY =
  'This camp tracks tasks with Festival, not a session todo list. Run `fest next` for the current task and `fest task completed` when it is done.'

async function runJson($: any, argv: string[]) {
  try {
    const r = await $.process.run(argv, { timeoutMs: 5000 })
    if (r.exitCode !== 0 || r.isStdoutTruncated) return null
    return JSON.parse(r.stdout)
  } catch {
    return null
  }
}

async function refresh($: any) {
  if ((await $.session.surfaces()).length === 0) return
  const next = bandOf(await runJson($, ['fest', 'next', '--json']))
  await update($, band, () => next)
  if (await read($, isOpen)) {
    const json = await runJson($, ['fest', 'show', '--json'])
    await update($, show, () => json?.view?.tree ? json : null)
  }
  $.ui.invalidate('ui.render')
}

function scheduleRefresh($: any): Promise<void> {
  return runRefresh(() => refresh($))
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
  const wantsTakeover = (options as { planningTakeover?: boolean } | undefined)?.planningTakeover === true

  on('session.start', async ($, e, next) => {
    for (const spec of COMMANDS) {
      try {
        await $.command.register(spec)
      } catch {}
    }
    try {
      isTakeover = wantsTakeover && (await campRoot(p => $.fs.exists(p), await $.session.cwd())) !== null
    } catch {
      isTakeover = false
    }
    await scheduleRefresh($)
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

  on('agent.offer', ($, e, next) =>
    isTakeover && e.agent === 'Plan' ? { isOffered: false } : next(e),
  ).catch(($, e, next) => next(e))

  on('tool.call', { tool: 'EnterPlanMode' }, ($, e, next) =>
    isTakeover ? { deny: PLAN_DENY } : next(e),
  ).catch(($, e, next) => next(e))
  on('tool.call', { tool: ['TodoWrite', 'TaskCreate'] }, ($, e, next) =>
    isTakeover ? { deny: TODO_DENY } : next(e),
  ).catch(($, e, next) => next(e))
  on('prompt.attachment', { type: 'todo_reminder' }, ($, e, next) =>
    isTakeover ? { text: null } : next(e),
  ).catch(($, e, next) => next(e))

  on('command.run', { command: 'fest-task' }, async $ => ({ text: await plain($, ['fest', 'next']) }))
    .catch(() => ({ text: 'fest-task failed; run `fest next` in a terminal.' }))
  on('command.run', { command: 'fest-progress' }, async $ => ({ text: await plain($, ['fest', 'progress']) }))
    .catch(() => ({ text: 'fest-progress failed; run `fest progress` in a terminal.' }))

  on('command.run', { command: 'fest-watch' }, async $ => {
    if (await read($, isOpen)) {
      await $.ui.close({ id: PANE })
      return { text: 'Festival pane closed.' }
    }
    await update($, isOpen, () => true)
    await $.ui.open({ id: PANE, title: 'Festival' })
    await scheduleRefresh($)
    timer?.cancel()
    timer = $.clock.every(5000, () => void scheduleRefresh($))
    return { text: 'Festival pane opened.' }
  }).catch(() => ({ text: 'The Festival pane could not be toggled.' }))

  on('ui.close', async ($, e, next) => {
    if (e.id === PANE) {
      timer?.cancel()
      timer = null
      await update($, isOpen, () => false)
    }
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
    const data = await read($, show)
    if (!data) return <Text dimColor>No festival here (fest show failed).</Text>
    const room = Math.max(3, (e.viewport?.rows ?? 24) - 6)
    const rows = rowsOf(data.view.tree)
    const start = windowStart(rows, room)
    return (
      <Box flexDirection="column">
        <Text color="claude" bold>{progressOf(data)}</Text>
        {rows.slice(start, start + room).map(r => (
          <Text color={STATUS_COLOR[r.status] ?? 'text'} bold={r.status === 'in_progress'}>
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
