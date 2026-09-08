// Run after a production Hugo and Pagefind build:
// DOCS_SITE_DIR=/path/to/build node --test scripts/test_docs_discovery.mjs
import assert from 'node:assert/strict';
import { existsSync, readFileSync, statSync } from 'node:fs';
import { resolve } from 'node:path';
import test from 'node:test';

const site = resolve(process.env.DOCS_SITE_DIR || 'public');
const origin = 'https://docs.fest.build';

const newRoutes = [
  '/getting-started/festival-manager/',
  '/guides/everyday-development/',
  '/use-cases/incident-investigation/',
  '/use-cases/research-and-analysis/',
  '/use-cases/support-escalation/',
  '/use-cases/infrastructure-changes/',
];
const useCaseRoutes = newRoutes.filter((route) => route.startsWith('/use-cases/'));
const changedAuthoredRoutes = [
  ...newRoutes,
  '/use-cases/ai-agent-project-management/',
  '/use-cases/long-running-ai-coding-sessions/',
  '/use-cases/claude-code-project-management/',
  '/use-cases/ai-agent-handoff/',
  '/methodology/why-festival/',
  '/methodology/overview/',
  '/guides/agent-workflows/',
  '/compare/festival-vs-issue-trackers/',
];
const agentHubRoute = '/getting-started/agents/';
const cliRoute = '/cli-reference/fest/fest_next/';
const socialImageURL = 'https://fest.build/opengraph-image';

function outputPath(route) {
  const relative = route.replace(/^\/+/, '');
  if (!relative) return resolve(site, 'index.html');
  return resolve(site, relative, 'index.html');
}

function page(route) {
  const path = outputPath(route);
  assert.ok(existsSync(path), `missing built page: ${route}`);
  return readFileSync(path, 'utf8');
}

function firstMatch(html, pattern, label) {
  const match = html.match(pattern);
  assert.ok(match, `missing ${label}`);
  return match[1];
}

function attribute(html, name, value) {
  return firstMatch(
    html,
    new RegExp(`<meta\\s+${name}="${value}"\\s+content="([^"]*)"`, 'i'),
    `${name}=${value}`,
  );
}

function pageMetadata(html, route) {
  const title = firstMatch(html, /<title>([\s\S]*?)<\/title>/i, `title for ${route}`);
  const description = attribute(html, 'name', 'description');
  const canonical = firstMatch(
    html,
    /<link\s+rel="canonical"\s+href="([^"]+)"/i,
    `canonical for ${route}`,
  );
  const ogTitle = attribute(html, 'property', 'og:title');
  const ogDescription = attribute(html, 'property', 'og:description');
  const ogURL = attribute(html, 'property', 'og:url');
  const ogImage = attribute(html, 'property', 'og:image');
  return { title, description, canonical, ogTitle, ogDescription, ogURL, ogImage };
}

function typeIncludes(value, expected) {
  return Array.isArray(value) ? value.includes(expected) : value === expected;
}

function jsonldGraph(html, route) {
  const scripts = [...html.matchAll(
    /<script\s+type="application\/ld\+json">([\s\S]*?)<\/script>/gi,
  )];
  assert.ok(scripts.length > 0, `missing JSON-LD for ${route}`);

  const schemas = scripts.map((match) => {
    try {
      return JSON.parse(match[1]);
    } catch (error) {
      assert.fail(`invalid JSON-LD for ${route}: ${error.message}`);
    }
  });
  return schemas.flatMap((schema) => (
    Array.isArray(schema['@graph']) ? schema['@graph'] : [schema]
  ));
}

function assertBreadcrumbs(html, route) {
  const graph = jsonldGraph(html, route);
  const breadcrumb = graph.find((schema) => typeIncludes(schema['@type'], 'BreadcrumbList'));
  assert.ok(breadcrumb, `missing BreadcrumbList for ${route}`);
  assert.ok(Array.isArray(breadcrumb.itemListElement), `breadcrumb items missing for ${route}`);
  assert.ok(breadcrumb.itemListElement.length > 0, `breadcrumb list empty for ${route}`);

  breadcrumb.itemListElement.forEach((item, index) => {
    assert.equal(item.position, index + 1, `breadcrumb position ${index + 1} invalid for ${route}`);
    assert.ok(item.name, `breadcrumb name ${index + 1} missing for ${route}`);
    assert.match(item.item, /^https:\/\/docs\.fest\.build\//, `breadcrumb URL ${index + 1} invalid for ${route}`);
  });
}

function assertLocalReferences(html, route) {
  const pageURL = new URL(`${origin}${route}`);
  for (const match of html.matchAll(/\s(?:href|src)="([^"]+)"/gi)) {
    const reference = match[1].replaceAll('&amp;', '&');
    if (reference.startsWith('data:') || reference.startsWith('javascript:')) continue;

    let url;
    try {
      url = new URL(reference, pageURL);
    } catch {
      assert.fail(`invalid URL in ${route}: ${reference}`);
    }
    if (url.origin !== origin || !['http:', 'https:'].includes(url.protocol)) continue;

    const pathname = decodeURIComponent(url.pathname);
    let target = resolve(site, pathname.replace(/^\/+/, ''));
    if (pathname.endsWith('/')) target = resolve(target, 'index.html');
    assert.ok(existsSync(target), `missing local reference from ${route}: ${reference}`);

    if (url.hash && statSync(target).isFile() && target.endsWith('.html')) {
      const targetHTML = readFileSync(target, 'utf8');
      const fragment = decodeURIComponent(url.hash.slice(1));
      assert.match(
        targetHTML,
        new RegExp(`(?:id|name)="${fragment.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}"`),
        `missing anchor from ${route}: ${reference}`,
      );
    }
  }
}

test('production build contains the six new guide and use-case routes', () => {
  for (const route of newRoutes) page(route);
});

test('new authored pages have unique metadata and self-canonical HTTPS URLs', () => {
  const metadata = changedAuthoredRoutes.map((route) => pageMetadata(page(route), route));
  const titles = new Set();
  const descriptions = new Set();

  metadata.forEach((meta, index) => {
    const route = changedAuthoredRoutes[index];
    assert.ok(meta.title.trim(), `empty title for ${route}`);
    assert.ok(meta.description.trim(), `empty description for ${route}`);
    titles.add(meta.title);
    descriptions.add(meta.description);
    assert.equal(meta.canonical, `${origin}${route}`);
    assert.equal(meta.ogTitle, meta.title, `OG title mismatch for ${route}`);
    assert.equal(meta.ogDescription, meta.description, `OG description mismatch for ${route}`);
    assert.equal(meta.ogURL, meta.canonical, `OG URL mismatch for ${route}`);
    assert.equal(meta.ogImage, socialImageURL, `OG image mismatch for ${route}`);
    assert.doesNotMatch(page(route), /<meta\s+name="robots"\s+content="noindex, nofollow"/i);
  });

  assert.equal(titles.size, changedAuthoredRoutes.length, 'changed authored pages must have unique titles');
  assert.equal(descriptions.size, changedAuthoredRoutes.length, 'changed authored pages must have unique descriptions');
});

test('authored pages and a generated CLI page have one H1 and valid breadcrumb JSON-LD', () => {
  for (const route of [...changedAuthoredRoutes, cliRoute]) {
    const html = page(route);
    assert.equal((html.match(/<h1\b[^>]*>/gi) || []).length, 1, `expected one H1 for ${route}`);
    assertBreadcrumbs(html, route);
  }

  // The home page has valid JSON-LD but no breadcrumb list because it is the root.
  const home = page('/');
  assert.equal((home.match(/<h1\b[^>]*>/gi) || []).length, 1, 'expected one H1 for home');
  assert.ok(jsonldGraph(home, '/').length > 0, 'missing JSON-LD for home');
});

test('use-case pages include the generated Quick Start CTA', () => {
  for (const route of useCaseRoutes) {
    const html = page(route);
    const cta = firstMatch(
      html,
      /(<aside[^>]+aria-label="Try Festival"[\s\S]*?<\/aside>)/i,
      `CTA aside for ${route}`,
    );
    assert.match(cta, /href="\/getting-started\/quickstart\/"/i, `missing Quick Start CTA link for ${route}`);
  }
});

test('documentation menu exposes new routes and the agent hub exposes deep setup guides', () => {
  const menuHTML = page(newRoutes[0]);
  for (const route of newRoutes) assert.match(menuHTML, new RegExp(route.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')));

  const agentHub = page(agentHubRoute);
  const agentHubURL = new URL(`${origin}${agentHubRoute}`);
  const agentLinks = [...agentHub.matchAll(/\s(?:href)="([^"]+)"/gi)].map((match) => match[1]);
  for (const slug of ['claude-code', 'codex', 'cursor', 'gemini', 'hermes', 'opencode', 'other-agents']) {
    const expectedPath = new URL(`${slug}/`, agentHubURL).pathname;
    assert.ok(
      agentLinks.some((href) => new URL(href, agentHubURL).pathname === expectedPath),
      `missing deep agent link: ${slug}`,
    );
  }
});

test('curated hubs do not append duplicate automatic child lists', () => {
  for (const route of ['/getting-started/', '/use-cases/', agentHubRoute]) {
    assert.doesNotMatch(page(route), /<div style="margin-bottom: 0\.5rem;">/i, `automatic child list leaked into ${route}`);
  }
});

test('Pagefind indexes main content and not the body element', () => {
  for (const route of ['/', ...newRoutes, cliRoute]) {
    const html = page(route);
    assert.equal((html.match(/<main\b[^>]*data-pagefind-body[^>]*>/gi) || []).length, 1, `missing Pagefind main marker for ${route}`);
    assert.doesNotMatch(html, /<body\b[^>]*data-pagefind-body/i, `Pagefind marker moved to body for ${route}`);
  }
});

test('production robots and sitemap permit crawling', () => {
  const robots = readFileSync(resolve(site, 'robots.txt'), 'utf8');
  assert.match(robots, /^User-agent:\s*\*\s*$/m);
  assert.match(robots, /^Allow:\s*\/\s*$/m);
  assert.match(robots, /^Sitemap:\s*https:\/\/docs\.fest\.build\/sitemap\.xml\s*$/m);
  const sitemap = readFileSync(resolve(site, 'sitemap.xml'), 'utf8');
  assert.match(sitemap, /<urlset[\s>]/i);
  assert.match(sitemap, /<loc>https:\/\/docs\.fest\.build\//i);
  for (const route of newRoutes) {
    const expected = `${origin}${route}`.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    assert.match(sitemap, new RegExp(`<loc>${expected}</loc>`));
  }
});

test('touched pages have resolvable local links, assets, and anchors', () => {
  const routes = [
    '/',
    '/getting-started/',
    agentHubRoute,
    '/use-cases/',
    ...changedAuthoredRoutes,
    cliRoute,
  ];
  for (const route of routes) assertLocalReferences(page(route), route);
});

test('local preview disables indexing and production analytics', { skip: !process.env.DOCS_PREVIEW_DIR }, () => {
  const preview = resolve(process.env.DOCS_PREVIEW_DIR);
  for (const route of ['/', '/use-cases/', '/getting-started/festival-manager/']) {
    const html = readFileSync(resolve(preview, route.replace(/^\/+/, ''), 'index.html'), 'utf8');
    assert.match(html, /<meta name="robots" content="noindex, nofollow">/);
    assert.doesNotMatch(html, /googletagmanager\.com|gtag\('config'/);
  }
  assert.match(readFileSync(resolve(preview, 'robots.txt'), 'utf8'), /^Disallow:\s*\/\s*$/m);
});
