export type FestNode = {
  name: string
  status: string
  node_type: string
  children?: FestNode[]
}

export type FestShow = {
  stats: { tasks: { total: number; completed: number }; progress: number }
  view: { tree: FestNode }
}

declare module 'claude-code' {
  interface PluginState {
    'festival': {
      band: string | null
      focus: string[] | null
      show: FestShow | null
      isOpen: boolean
    }
  }
}
