export const meta = {
  name: 'audit-tasks',
  description: 'Audit every unblocked festival task for tutorial-grade quality, verifying each finding before reporting',
  whenToUse:
    'Run on a planned festival before executing it. fest validate scores structure, not substance, so a festival of one-line tasks validates at 100. This reads the actual task documents.',
  phases: [
    { title: 'Survey', detail: 'read the ready set from fest deps --ready' },
    { title: 'Audit', detail: 'one agent per ready task' },
    { title: 'Verify', detail: 'refute each finding before it is reported' },
  ],
}

const READY_SCHEMA = {
  type: 'object',
  required: ['tasks'],
  properties: {
    tasks: {
      type: 'array',
      items: {
        type: 'object',
        required: ['name', 'path'],
        properties: {
          name: { type: 'string' },
          path: { type: 'string' },
        },
      },
    },
  },
}

const FINDINGS_SCHEMA = {
  type: 'object',
  required: ['findings'],
  properties: {
    findings: {
      type: 'array',
      items: {
        type: 'object',
        required: ['kind', 'detail'],
        properties: {
          kind: {
            type: 'string',
            enum: ['thin', 'no-files-named', 'no-error-paths', 'unverifiable-anchor', 'no-done-criteria'],
          },
          detail: { type: 'string' },
          anchor: { type: 'string' },
        },
      },
    },
  },
}

const VERDICT_SCHEMA = {
  type: 'object',
  required: ['refuted', 'reason'],
  properties: {
    refuted: { type: 'boolean' },
    reason: { type: 'string' },
  },
}

phase('Survey')

const ready = await agent(
  `Run \`fest deps --ready --all --json\` from the festival directory and return its tasks array.
Each entry has a "name" and an absolute "path". Return them unchanged.
If the command reports it is not inside a festival, return an empty tasks array.`,
  { label: 'ready-set', schema: READY_SCHEMA },
)

const tasks = ready?.tasks ?? []

if (tasks.length === 0) {
  log('No unblocked tasks. Nothing to audit.')
  return { audited: 0, findings: [] }
}

log(`Auditing ${tasks.length} unblocked task${tasks.length === 1 ? '' : 's'}.`)

// Pipeline, not a barrier: a task's findings go straight to verification while
// other tasks are still being read.
const results = await pipeline(
  tasks,
  (task) =>
    agent(
      `Read the festival task document at ${task.path} and judge whether it is tutorial-grade.

A task document is read by an agent that has none of the planning conversation's
context. It assumes the reader knows the codebase and nothing else. Report a
finding only where the document actually falls short:

- thin: the task states an intent but not the work.
- no-files-named: it does not say which files it touches.
- no-error-paths: it describes only the happy path.
- unverifiable-anchor: it cites a file:line that does not exist or does not
  contain what the task claims. OPEN THE FILE AND CHECK. This is the most
  valuable finding and the most common defect, because plausible-sounding
  anchors get written without being verified.
- no-done-criteria: there is no way for someone else to check it is finished.

Return an empty findings array if the document is genuinely sound. Do not invent
findings to look thorough.`,
      { label: `audit:${task.name}`, phase: 'Audit', schema: FINDINGS_SCHEMA },
    ),
  (audit, task) =>
    parallel(
      (audit?.findings ?? []).map((finding) => () =>
        agent(
          `Try to REFUTE this finding about the festival task at ${task.path}.

Finding (${finding.kind}): ${finding.detail}${finding.anchor ? `\nAnchor: ${finding.anchor}` : ''}

Read the document yourself. If the task document actually does the thing the
finding says is missing, the finding is refuted. Default to refuted=true when
you are uncertain: a false complaint about a good task costs more than a missed
one, because it teaches the author to ignore this audit.`,
          { label: `verify:${task.name}`, phase: 'Verify', schema: VERDICT_SCHEMA },
        ).then((verdict) => ({
          task: task.name,
          path: task.path,
          kind: finding.kind,
          detail: finding.detail,
          anchor: finding.anchor,
          refuted: verdict?.refuted ?? true,
          reason: verdict?.reason ?? 'verification did not complete; treated as refuted',
        })),
      ),
    ),
)

const confirmed = results
  .filter(Boolean)
  .flat()
  .filter(Boolean)
  .filter((finding) => !finding.refuted)

log(`${confirmed.length} finding${confirmed.length === 1 ? '' : 's'} survived verification.`)

return {
  audited: tasks.length,
  findings: confirmed,
}
