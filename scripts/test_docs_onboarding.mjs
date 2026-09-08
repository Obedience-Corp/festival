// Run after Hugo and Pagefind: DOCS_SITE_DIR=/path/to/build node --test scripts/test_docs_onboarding.mjs
import assert from 'node:assert/strict';
import { readFileSync, existsSync, statSync } from 'node:fs';
import { resolve } from 'node:path';
import test from 'node:test';
import vm from 'node:vm';

const site = resolve(process.env.DOCS_SITE_DIR || 'public');
const guide = readFileSync(resolve(site, 'getting-started/quickstart/index.html'), 'utf8');
const home = readFileSync(resolve(site, 'index.html'), 'utf8');
const script = readFileSync(new URL('../themes/festival/assets/js/terminal-recordings.js', import.meta.url), 'utf8');

test('Quick Start has four ordered stages, two prompts, and three captioned recordings', () => {
  const stages = ['install', 'create-a-camp', 'hand-off-a-goal', 'run-review-and-resume'];
  let previous = -1;
  for (const stage of stages) {
    const position = guide.indexOf(`id="${stage}"`);
    assert.ok(position > previous, `missing or out-of-order stage: ${stage}`);
    previous = position;
  }
  assert.equal((guide.match(/data-lang="agent-prompt"/g) || []).length, 2);
  assert.equal((guide.match(/data-demo-src=/g) || []).length, 3);
  assert.equal((guide.match(/<figcaption>/g) || []).length, 3);
  assert.match(guide, /content-area--with-toc/);
  assert.doesNotMatch(guide, /proof-loop\.gif|under 5 minutes/);
  for (const name of ['tui-setup', 'tui-delegate', 'tui-fest-watch']) {
    assert.match(guide, new RegExp(`src="/images/demos/${name}-poster\\.png"`));
    assert.ok(existsSync(resolve(site, `images/demos/${name}.gif`)));
    assert.ok(existsSync(resolve(site, `images/demos/${name}-poster.png`)));
  }
});

test('all local Quick Start links and fragments resolve in the built site', () => {
  for (const [, href] of guide.matchAll(/href="([^"]+)"/g)) {
    if (!href.startsWith('/') && !href.startsWith('#')) continue;
    const url = new URL(href.replaceAll('&amp;', '&'), 'https://docs.fest.build/getting-started/quickstart/');
    let target = resolve(site, `.${decodeURIComponent(url.pathname)}`);
    assert.ok(existsSync(target), `missing link: ${href}`);
    if (statSync(target).isDirectory()) target = resolve(target, 'index.html');
    assert.ok(existsSync(target), `missing page: ${href}`);
    if (url.hash) {
      const html = readFileSync(target, 'utf8');
      assert.ok(html.includes(`id="${decodeURIComponent(url.hash.slice(1))}"`), `missing anchor: ${href}`);
    }
  }
});

test('landing page keeps its video overview and points into the guide', () => {
  assert.match(home, /id="how-it-works"/);
  for (const name of ['tui-setup', 'tui-delegate', 'tui-fest-watch', 'tui-workitems']) {
    assert.ok(home.includes(`/images/demos/${name}.gif`));
  }
  for (const anchor of ['create-a-camp', 'hand-off-a-goal', 'run-review-and-resume']) {
    assert.ok(home.includes(`/getting-started/quickstart/#${anchor}`));
  }
  assert.match(home, /Start with the guide/);
});

function events(properties = {}) {
  const listeners = new Map();
  return Object.assign(properties, {
    addEventListener(name, callback) {
      if (!listeners.has(name)) listeners.set(name, []);
      listeners.get(name).push(callback);
    },
    emit(name) { for (const callback of listeners.get(name) || []) callback(); },
  });
}

function player({ reduced = false, observer = true } = {}) {
  const attrs = { src: '/poster.png' };
  const img = events({
    getAttribute: (key) => attrs[key],
    setAttribute: (key, value) => { attrs[key] = value; },
  });
  const button = events({ hidden: true, setAttribute(key, value) { this[key] = value; } });
  const recording = {
    dataset: { demoSrc: '/demo.gif', demoPoster: '/poster.png', demoTitle: 'Camp setup' },
    querySelector: (selector) => selector === 'img' ? img : button,
  };
  const motion = events({ matches: reduced });
  const document = events({ hidden: false, querySelectorAll: () => [recording] });
  let visibility;
  const IntersectionObserver = class {
    constructor(callback) { visibility = callback; }
    observe(target) { assert.equal(target, recording); }
  };
  const window = { matchMedia: () => motion };
  if (observer) window.IntersectionObserver = IntersectionObserver;
  vm.runInNewContext(script, { window, document, IntersectionObserver });
  return {
    img, button, motion, document,
    src: () => attrs.src,
    view: (visible) => visibility([{ isIntersecting: visible }]),
  };
}

test('recordings autoplay in view, pause to a poster, and retain a manual pause across scrolling', () => {
  const p = player();
  assert.equal(p.src(), '/poster.png');
  assert.equal(p.button.hidden, false);
  p.view(true);
  assert.equal(p.src(), '/demo.gif');
  assert.equal(p.button['aria-label'], 'Pause animation: Camp setup');
  p.button.emit('click');
  assert.equal(p.src(), '/poster.png');
  p.view(false);
  p.view(true);
  assert.equal(p.src(), '/poster.png');
  p.button.emit('click');
  assert.equal(p.src(), '/demo.gif');
  p.view(false);
  assert.equal(p.src(), '/poster.png');
  p.view(true);
  assert.equal(p.src(), '/demo.gif');
});

test('reduced motion uses posters, allows explicit play, and follows preference changes', () => {
  const p = player({ reduced: true });
  p.view(true);
  assert.equal(p.src(), '/poster.png');
  p.button.emit('click');
  assert.equal(p.src(), '/demo.gif');
  p.motion.emit('change');
  assert.equal(p.src(), '/poster.png');
  p.motion.matches = false;
  p.motion.emit('change');
  assert.equal(p.src(), '/demo.gif');
});

test('hidden tabs stop animation and media failures leave a usable static preview', () => {
  const p = player();
  p.view(true);
  p.document.hidden = true;
  p.document.emit('visibilitychange');
  assert.equal(p.src(), '/poster.png');
  p.document.hidden = false;
  p.document.emit('visibilitychange');
  assert.equal(p.src(), '/demo.gif');
  p.img.emit('error');
  assert.equal(p.src(), '/poster.png');
  assert.equal(p.button.disabled, true);
  assert.equal(p.button.textContent, 'Animation unavailable');
});

test('browsers without IntersectionObserver retain working play and pause', () => {
  const p = player({ observer: false });
  assert.equal(p.src(), '/demo.gif');
  p.button.emit('click');
  assert.equal(p.src(), '/poster.png');
});
