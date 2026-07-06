---
title: "Camp and Fest Plugins"
---

# Camp and Fest Plugins

Camp and Fest plugins use the same idea as Git plugins: put an executable with
the right name on your `PATH`, and the CLI can run it as a subcommand.

That is all a basic plugin needs.

## The Short Version

For Camp, create an executable named:

```text
camp-<name>
```

Then run it as:

```bash
camp <name>
```

For Fest, create an executable named:

```text
fest-<name>
```

Then run it as:

```bash
fest <name>
```

The plugin can be a shell script, Python script, Go binary, Node script, Rust
binary, or anything else your operating system can execute.

## Create A Camp Plugin

Create a file named `camp-hello`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "hello from a camp plugin"
echo "args: $*"
```

Make it executable and place it somewhere on your `PATH`:

```bash
chmod +x camp-hello
mkdir -p ~/.local/bin
mv camp-hello ~/.local/bin/
```

Make sure `~/.local/bin` is on your `PATH`, then run:

```bash
camp hello
camp hello --name Ada
```

Camp looks for `camp-hello`, runs it, and forwards the arguments after
`hello`. If Camp can detect the current campaign root, it also sets `CAMP_ROOT`
for the plugin process.

The current public example of this pattern is `camp-graph`: installing the
`camp-graph` executable makes `camp graph` available.

## Create A Fest Plugin

Create a file named `fest-stats`:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "festival stats plugin"
echo "args: $*"
```

Make it executable and place it somewhere on your `PATH`:

```bash
chmod +x fest-stats
mkdir -p ~/.local/bin
mv fest-stats ~/.local/bin/
```

Then run:

```bash
fest stats
```

Fest also supports two-word plugin commands. An executable named
`fest-export-jira` can be run as:

```bash
fest export jira
```

When Fest runs a plugin, it sets:

```text
FEST_PLUGIN=1
FEST_PLUGIN_COMMAND=<resolved command>
```

## Optional Fest Manifest

Fest can discover simple `fest-*` executables directly from `PATH`. A manifest
is optional; use one when you want richer metadata such as summaries, examples,
or usage hints.

```yaml
version: 1
plugins:
  - command: "export jira"
    exec: "fest-export-jira"
    summary: "Export festival work to Jira"
    examples:
      - "fest export jira --project PROJ"
```

Manifest-based plugins are useful for team config repos and future help
surfaces. For a first plugin, start with an executable on `PATH`.

## Shipping Support Files

Many plugins need only the executable. If your plugin is a single binary or
script, installing that executable on `PATH` is enough.

Some plugins ship support files such as templates, schemas, static web assets,
or helper scripts. How you package those files is up to you. Use a stable path,
document it, and make your plugin's error messages explain how to repair a
missing install.

Obedience Corp supplied plugins use this managed asset convention:

```text
~/.obey/plugins/<plugin-name>/
```

That path is for first-party Obedience Corp plugins that need runtime assets
outside the source checkout. It lets users and support tools find first-party
plugin files consistently. You can follow the same convention for your own
plugin if you want, but user-created plugins are not required to store assets
there.

## Checklist

- Name the executable `camp-<name>` or `fest-<name>`.
- Put it on `PATH`.
- Make it executable.
- Read arguments from `argv` like any normal CLI.
- Exit non-zero when the plugin fails.
- Print clear repair steps when required files or tools are missing.
