import type { FestNode, FestView, WorkflowStep } from '../../types/index'

const MARKS: Record<string, string> = {
  completed: '[x]',
  in_progress: '[~]',
  pending: '[ ]',
  blocked: '[!]',
  skipped: '[-]',
}

export const STATUS_COLOR: Record<string, string> = {
  completed: 'success',
  in_progress: 'warning',
  blocked: 'error',
  pending: 'inactive',
  skipped: 'inactive',
}

const FINISHED = new Set(['completed', 'skipped'])

const last = (path: string) => path.split('/').filter(Boolean).pop() ?? path
const bare = (name: string) => name.replace(/\.md$/, '')

const isText = (v: unknown): v is string => typeof v === 'string'

function nodeOf(raw: any): FestNode | null {
  if (!raw || typeof raw !== 'object' || !isText(raw.name) || !isText(raw.status)) return null
  const kids = Array.isArray(raw.children) ? raw.children.map(nodeOf) : []
  if (kids.some((k: FestNode | null) => k === null)) return null
  return { name: raw.name, status: raw.status, node_type: isText(raw.node_type) ? raw.node_type : '', children: kids }
}

function stepOf(raw: any): WorkflowStep | null {
  if (!raw || typeof raw !== 'object' || typeof raw.number !== 'number' || !isText(raw.name) || !isText(raw.status)) return null
  return { number: raw.number, name: raw.name, status: raw.status }
}

export function viewOf(json: any): FestView | null {
  if (!json || typeof json !== 'object') return null
  if (isText(json.mode) && json.mode.startsWith('standalone')) {
    const raw = Array.isArray(json.steps) ? json.steps : []
    const steps = raw.map(stepOf)
    if (steps.some((s: WorkflowStep | null) => s === null)) return null
    const doc = isText(json.workflow_doc) ? json.workflow_doc : ''
    return {
      kind: 'workflow',
      name: last(doc.replace(/\/WORKFLOW\.md$/, '')) || 'workflow',
      runStatus: isText(json.run_status) ? json.run_status : '',
      steps: steps as WorkflowStep[],
    }
  }
  const tree = nodeOf(json.view?.tree)
  const tasks = json.stats?.tasks
  if (tree && tasks && typeof tasks.total === 'number' && typeof tasks.completed === 'number' && typeof json.stats.progress === 'number') {
    return {
      kind: 'festival',
      name: isText(json.name) ? json.name : tree.name,
      tree,
      stats: { tasks: { total: tasks.total, completed: tasks.completed }, progress: json.stats.progress },
    }
  }
  return null
}

export type Row = { depth: number; text: string; status: string; path: string[] }

export function rowsOf(node: FestNode, depth = 0, expand = true, path: string[] = []): Row[] {
  const mark = MARKS[node.status] ?? '[?]'
  const rows: Row[] = [{ depth, text: `${mark} ${bare(node.name)}`, status: node.status, path }]
  const kids = node.children ?? []
  if (!expand) return rows
  const first = kids.findIndex(k => !FINISHED.has(k.status))
  const below = depth === 0 ? [] : [...path, bare(node.name)]
  kids.forEach((k, i) => {
    const open = k.status === 'in_progress' || k.status === 'blocked' || i === first
    rows.push(...rowsOf(k, depth + 1, open, below))
  })
  return rows
}

export function stepRows(steps: WorkflowStep[]): Row[] {
  return steps.map(s => ({ depth: 0, text: `${MARKS[s.status] ?? '[?]'} ${s.number} ${s.name}`, status: s.status, path: [] }))
}

export function currentRow(rows: Row[]): number {
  const isLeaf = (i: number) => i + 1 >= rows.length || rows[i + 1]!.depth <= rows[i]!.depth
  const active = rows.findIndex((r, i) => r.status === 'in_progress' && isLeaf(i))
  if (active !== -1) return active
  return rows.findIndex((r, i) => !FINISHED.has(r.status) && isLeaf(i))
}

export function windowStart(rows: Row[], room: number): number {
  const cur = Math.max(0, currentRow(rows))
  return Math.max(0, Math.min(cur - Math.floor(room / 3), rows.length - room))
}

export function rowsOfView(view: FestView): Row[] {
  return view.kind === 'festival' ? rowsOf(view.tree) : stepRows(view.steps)
}

export function headerOf(view: FestView): string {
  if (view.kind === 'festival') {
    const t = view.stats.tasks
    return `tasks ${t.completed}/${t.total} (${view.stats.progress}%)`
  }
  const done = view.steps.filter(s => FINISHED.has(s.status)).length
  return `steps ${done}/${view.steps.length}`
}

export function bandOf(view: FestView | null): string | null {
  if (!view) return null
  const rows = rowsOfView(view)
  const cur = currentRow(rows)
  const row = cur === -1 ? null : rows[cur]!
  const flag = row?.status === 'blocked' ? ' (blocked)' : ''
  if (view.kind === 'festival') {
    const count = headerOf(view).replace(/^tasks /, '')
    if (!row || view.tree.status === 'completed') return `festival ${view.name} | complete | ${count}`
    const where = [...row.path, row.text.slice(4)].join(' > ')
    return `festival ${view.name} | ${where}${flag} | ${count}`
  }
  if (view.steps.length === 0) return `workflow ${view.name} | no run`
  const count = `${headerOf(view).replace(/^steps /, '')} steps`
  if (!row || view.runStatus === 'completed') return `workflow ${view.name} | complete | ${count}`
  const step = view.steps[cur]!
  return `workflow ${view.name} | step ${step.number}/${view.steps.length}: ${step.name}${flag} | ${count}`
}

export const READ_ONLY_FEST = '0.9.3'
export const LEGACY_PROGRESS_FILES = ['progress.yaml', 'workflow_state.yaml']

export function versionAtLeast(text: string, want: string): boolean {
  const have = /v?(\d+)\.(\d+)\.(\d+)(-\S*)?/.exec(text)
  if (!have) return false
  const w = want.split('.').map(Number)
  for (let i = 0; i < 3; i++) {
    const h = Number(have[i + 1])
    if (h !== w[i]) return h > w[i]!
  }
  return have[4] === undefined
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
