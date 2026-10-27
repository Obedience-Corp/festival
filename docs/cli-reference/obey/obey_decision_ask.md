---
title: "obey decision ask"
linkTitle: "obey decision ask"
description: "Ask a named or ad hoc decision and print the answers as JSON"
---

## obey decision ask

Ask a named or ad hoc decision and print the answers as JSON

### Synopsis

Ask a decision and print a JSON result on stdout: answers keyed by question id,
the versioned model id that answered, the provider request id, input tokens
(null when not reported), cost in USD from the rate card (null when tokens are
not reported), and latency.

State comes from --state-file, from --state, or from stdin when neither is
given. State that parses as JSON is sent as JSON; anything else is sent as a
string.

Questions come from the named decision, or from --questions-file for an ad hoc
decision with the same schema as one decisions.yaml entry.

The provider is the first of: --provider, the decision's provider:,
decisions.default_provider in daemon.yaml, or the single enabled decision
provider. A question kind the provider does not support fails before anything
is sent.

Without --timeout, each attempt may take 10s and the whole request, retries
included, 30s. --timeout replaces both limits: the request ends when it runs
out, and a single slow attempt may use all of it. Fast transient failures are
retried (up to 2 retries) while time remains.

The state and the questions are sent to the provider. obey does not log the
state or the API key.

```
obey decision ask [name] [flags]
```

### Examples

```
  # A starter decision from obey decision init, state inline
  obey decision ask needs_reply --state 'Can you send me the report by Friday?'

  # Named decision, state on stdin
  printf '%s' '{"task":"add retry","last_agent_message":"Done."}' | obey decision ask turn_outcome

  # Ad hoc questions, state from a file, pinned model
  obey decision ask --questions-file questions.yaml --state-file state.json --model jev-1.13.0
```

### Options

```
      --campaign string         campaign root for .obey/decisions.yaml (default: detected from the working directory)
  -h, --help                    help for ask
      --model string            model id (default: the decision's model, else the provider default_model)
      --provider string         decision provider profile (default: the decision's provider, then decisions.default_provider, then the single enabled one)
      --questions-file string   ad hoc decision definition (YAML or JSON) instead of a name
      --state string            state as JSON or text
      --state-file string       read state from this file
      --timeout duration        limit for the whole request, retries included, and for any one attempt, e.g. 5s or 2m (default: 10s per attempt, 30s in total)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey decision](../obey_decision/)	 - Ask a decision provider typed questions about some state
