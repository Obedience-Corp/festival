import type { FestNode, FestShow } from '../../types/index'

const MARKS: Record<string, string> = {
  completed: '[x]',
  in_progress: '[~]',
  pending: '[ ]',
  blocked: '[!]',
}

const last = (path: string) => path.split('/').filter(Boolean).pop() ?? path

export function bandOf(json: any): string | null {
  if (!json || typeof json !== 'object') return null
  if (json.mode?.startsWith('standalone')) {
    const name = last(json.workflow_doc ?? '').toLowerCase() === 'workflow.md'
      ? last((json.workflow_doc as string).replace(/\/WORKFLOW\.md$/, ''))
      : last(json.workflow_doc ?? 'workflow')
    return `workflow ${name} | step ${json.current_step}/${json.total_steps}: ${json.step_name}`
  }
  if (json.task || json.festival_complete !== undefined) {
    const fest = last(json.location?.festival_path ?? 'festival')
    const p = json.progress
    const count = p ? `${p.completed_tasks}/${p.total_tasks} (${p.percentage}%)` : ''
    const withCount = (s: string) => (count ? `${s} | ${count}` : s)
    if (json.task) {
      const t = json.task
      return withCount(`festival ${fest} | ${t.phase_name} > ${t.sequence_name} > ${t.name}`)
    }
    if (json.festival_complete === true) return withCount(`festival ${fest} | complete`)
    if (json.planning?.phase_name) return withCount(`festival ${fest} | ${json.planning.phase_name} (planning)`)
    if (json.festival_planning) return `festival ${fest} | planning`
    const why = typeof json.reason === 'string' && json.reason ? json.reason : 'no task ready'
    return withCount(`festival ${fest} | ${why.length > 60 ? `${why.slice(0, 59)}…` : why}`)
  }
  return null
}

export type Row = { depth: number; text: string; status: string; isFocus: boolean }

const bare = (name: string) => name.replace(/\.md$/, '')

export function focusOf(json: any): string[] | null {
  const t = json?.task
  if (!t || typeof t.name !== 'string') return null
  const path = [t.phase_name, t.sequence_name, t.name]
  return path.every(p => typeof p === 'string' && p) ? path.map(bare) : null
}

export function rowsOf(node: FestNode, focus: string[] | null = null, depth = 0, expand = true, onPath = true): Row[] {
  const mark = MARKS[node.status] ?? '[?]'
  const isFocus = onPath && focus !== null && depth === focus.length
  const rows: Row[] = [{ depth, text: `${mark} ${bare(node.name)}`, status: node.status, isFocus }]
  const kids = node.children ?? []
  if (!expand) return rows
  const first = kids.findIndex(k => k.status !== 'completed')
  kids.forEach((k, i) => {
    const kidOnPath = onPath && focus !== null && depth < focus.length && bare(k.name) === focus[depth]
    const open = kidOnPath || k.status === 'in_progress' || (focus === null && i === first)
    rows.push(...rowsOf(k, focus, depth + 1, open, kidOnPath))
  })
  return rows
}

export function currentRow(rows: Row[]): number {
  const isLeaf = (i: number) => i + 1 >= rows.length || rows[i + 1]!.depth <= rows[i]!.depth
  const focused = rows.findIndex(r => r.isFocus)
  if (focused !== -1) return focused
  const active = rows.findIndex((r, i) => r.status === 'in_progress' && isLeaf(i))
  if (active !== -1) return active
  const open = rows.findIndex((r, i) => r.status !== 'completed' && isLeaf(i))
  return open === -1 ? 0 : open
}

export function windowStart(rows: Row[], room: number): number {
  const lead = Math.floor(room / 3)
  return Math.max(0, Math.min(currentRow(rows) - lead, rows.length - room))
}

export function progressOf(show: FestShow): string {
  const t = show.stats.tasks
  return `tasks ${t.completed}/${t.total} (${show.stats.progress}%)`
}

export const STATUS_COLOR: Record<string, string> = {
  completed: 'success',
  in_progress: 'warning',
  blocked: 'error',
  pending: 'inactive',
}

export function coalesce(): (run: () => Promise<void>) => Promise<void> {
  let busy: Promise<void> | null = null
  let pending: (() => Promise<void>) | null = null
  return run => {
    if (busy) {
      pending = run
      return busy
    }
    busy = (async () => {
      let current: (() => Promise<void>) | null = run
      try {
        while (current) {
          pending = null
          try {
            await current()
          } catch {}
          current = pending
        }
      } finally {
        busy = null
      }
    })()
    return busy
  }
}
