export async function campRoot(
  exists: (path: string) => Promise<boolean>,
  cwd: string,
): Promise<string | null> {
  let dir = cwd.replace(/\/+$/, '')
  while (dir !== '') {
    if (await exists(`${dir}/.campaign`)) return dir
    dir = dir.slice(0, dir.lastIndexOf('/'))
  }
  return (await exists('/.campaign')) ? '/' : null
}

export async function rootedPath(
  exists: (path: string) => Promise<boolean>,
  cwd: string,
  mention: string,
): Promise<string | null> {
  const rel = mention.replace(/#.*$/, '').replace(/^\.\//, '')
  if (rel === '' || rel.startsWith('/')) return null
  const root = await campRoot(exists, cwd)
  if (root === null) return null
  const candidate = `${root === '/' ? '' : root}/${rel}`
  return (await exists(candidate)) ? candidate : null
}
