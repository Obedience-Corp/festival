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
    if (!json.task) return `festival ${fest} | complete ${count}`
    const t = json.task
    return `festival ${fest} | ${t.phase_name} > ${t.sequence_name} > ${t.name} | ${count}`
  }
  return null
}

export type Row = { depth: number; text: string; status: string }

export function rowsOf(node: FestNode, depth = 0, expand = true): Row[] {
  const mark = MARKS[node.status] ?? '[?]'
  const rows: Row[] = [{ depth, text: `${mark} ${node.name.replace(/\.md$/, '')}`, status: node.status }]
  const kids = node.children ?? []
  if (!expand) return rows
  const current = kids.findIndex(k => k.status !== 'completed')
  kids.forEach((k, i) => {
    rows.push(...rowsOf(k, depth + 1, k.status === 'in_progress' || i === current))
  })
  return rows
}

export function currentRow(rows: Row[]): number {
  const isLeaf = (i: number) => i + 1 >= rows.length || rows[i + 1]!.depth <= rows[i]!.depth
  const i = rows.findIndex((r, idx) => r.status !== 'completed' && isLeaf(idx))
  return i === -1 ? 0 : i
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
