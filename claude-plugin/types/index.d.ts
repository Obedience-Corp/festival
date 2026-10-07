export type FestNode = {
  name: string
  status: string
  node_type: string
  children?: FestNode[]
}

export type WorkflowStep = {
  number: number
  name: string
  status: string
}

export type FestView =
  | {
      kind: 'festival'
      name: string
      tree: FestNode
      stats: { tasks: { total: number; completed: number }; progress: number }
    }
  | {
      kind: 'workflow'
      name: string
      runStatus: string
      steps: WorkflowStep[]
    }

declare module 'claude-code' {
  interface PluginState {
    'festival': {
      band: string | null
      view: FestView | null
      isOpen: boolean
      notice: string | null
    }
  }
}
