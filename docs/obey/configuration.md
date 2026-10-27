---
title: "Configure Obey and ob"
description: "Understand daemon settings, provider credentials, ob defaults, and per-camp overrides."
weight: 2
---

# Configure Obey and ob

The daemon and developer CLI have separate configuration. A provider can be
available in the daemon without being selected for `ob` commands.

| Location | What it controls |
| --- | --- |
| `~/.obey/daemon.yaml` | Daemon settings, provider profiles, and daemon-owned defaults. |
| `~/.obey/.env` | Provider credentials saved by the provider manager. |
| `~/.obey/ob.yaml` | Global `ob` preferences, including provider and model. |
| `<camp>/.ob/config.yaml` | `ob` preferences for one camp. |
| `<camp>/.campaign/ob/` | Camp-specific prompt templates and command definitions. |

`~` means your user home directory. These are user settings, not files you need
from the private source repository.

## Provider profiles and credentials

Start with the provider manager:

```sh
ob providers
```

Select a provider to inspect or configure it. Use **Add** for another named
profile. A profile names the adapter type, endpoint, credential reference, and
default model. Several profiles can use the same adapter with different accounts
or endpoints.

- CLI-backed providers, such as Claude Code and Codex, require their executable
  and that CLI's own authentication. A configured profile is not a replacement
  for signing in to the underlying CLI.
- Ollama requires a running local runtime and a model you have pulled.
- OpenAI and OpenRouter require a credential. OpenClaw requires its gateway
  configuration. Configure these through the manager before selecting them.
- Model discovery can be unavailable for a provider. Use manual model entry
  when supported, with an identifier accepted by that provider.

The manager hides credential values and stores managed secrets in
`~/.obey/.env`, with file mode `0600` on systems supporting Unix permissions.
Profiles refer to them through `api_key_env`; do not put secret values in a
camp's `ob` preferences. A value in the daemon's process environment takes
precedence over the same name in the managed `.env` file. A paid chat probe in
the provider manager is a separate action that asks for confirmation.

## Defaults for ob commands

Inspect the effective settings and where each value came from:

```sh
ob config show
ob settings get
ob settings get provider
```

Use `ob settings` for the interactive editor, or set individual values:

```sh
ob settings set provider claude-code
ob settings set model sonnet
ob settings set quiet true
```

Non-interactive writes are global unless you pass `--campaign`:

```sh
# Run inside the camp whose settings you want to change.
ob settings set model sonnet --campaign
ob settings get model
```

The precedence for ordinary settings is compiled defaults, then
`~/.obey/ob.yaml`, then the camp's `.ob/config.yaml`, then explicit command
flags. Inside a camp the interactive editor starts on the camp layer;
outside one it starts on the global layer. A global write does not displace a
camp override.

For a single invocation:

```sh
ob --provider claude-code --model sonnet plan spec.md
```

Prompt templates can also select a provider and model in their frontmatter.
Use `ob commands show plan` to inspect the command-specific resolution when a
prompt command runs with a different selection than expected.

## The daemon's default for other clients

The daemon has a separate default for clients that create a session without
specifying a provider:

```sh
obey providers set-default claude-code --model sonnet
obey providers
```

This writes the daemon-owned default. It does not replace `ob`'s global or
camp-specific settings. `obey run` requires an explicit provider and model.

## Daemon settings and restart

The default configuration file is `~/.obey/daemon.yaml`. `obey serve --config`
selects another file. Serve flags and `OBEY_*` environment variables can override
file settings; inspect `obey serve --help` for available startup options.

For local-only operation, merge this section into your existing configuration:

```yaml
network:
  enabled: false
```

Or use `obey serve --no-network` for a manually started daemon. Normal network
operation uses an authenticated TLS listener with device pairing. Do not confuse
network settings with provider credentials or the local CLI connection.

Manual edits to daemon runtime settings require a restart:

```sh
obey service restart
obey ping
```

A restart interrupts active daemon-owned work. Settings changed through the
provider manager use the daemon's provider-management path; follow the result
it reports rather than restarting for every `ob` preference edit.

## Connection and data paths

Use the resolver to inspect the local daemon endpoint:

```sh
obey socket-path
ob config show
```

`ob` has a `socket_path` setting and a `--socket` override. Point it at the same
daemon endpoint as `obey`; an explicit endpoint elsewhere disables `ob`'s
automatic startup of the default local daemon.

Daemon runtime data defaults to `~/.local/share/obey/`, separate from
`~/.obey/daemon.yaml`. `data_dir` in the daemon file or `OBEY_DATA_DIR` can change
that location. Changing the setting does not migrate existing data.

`obey config explain --json` explains **local inference runtime** settings and
their effective values. It is not a general dump of all daemon or `ob` settings.
Use `ob config show` for the developer CLI.
