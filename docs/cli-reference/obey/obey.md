---
title: "obey"
linkTitle: "obey"
description: "CLI for managing your agentic organization"
---

## obey

CLI for managing your agentic organization

### Synopsis

obey is the CLI for managing your agentic organization.

It monitors campaigns, tracks festival progress, and orchestrates
agent workflows across your development environment.

GETTING STARTED:
  obey serve              Start the daemon to monitor campaigns

CONFIGURATION:
  Config file:  ~/.obey/daemon.yaml
  Data dir:     ~/.local/share/obey/

Run 'obey serve --help' for daemon configuration options.

### Options

```
  -h, --help            help for obey
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey bridge](../obey_bridge/)	 - Bridge external terminal sessions into obey
* [obey campaign](../obey_campaign/)	 - Manage campaigns
* [obey chat](../obey_chat/)	 - Interactive chat attached to an agent session
* [obey completion](../obey_completion/)	 - Generate the autocompletion script for the specified shell
* [obey config](../obey_config/)	 - Inspect daemon configuration
* [obey count-tokens](../obey_count-tokens/)	 - Estimate token counts for a file or directory
* [obey decision](../obey_decision/)	 - Ask a decision provider typed questions about some state
* [obey defaults](../obey_defaults/)	 - Inspect the shipped defaults this binary carries
* [obey delegation](../obey_delegation/)	 - Manage delegation settings
* [obey devices](../obey_devices/)	 - Manage devices paired with this daemon
* [obey doctor](../obey_doctor/)	 - Check daemon health
* [obey exec](../obey_exec/)	 - Execute a command through the daemon
* [obey launch](../obey_launch/)	 - Start a new provider-backed session through obey
* [obey logs](../obey_logs/)	 - Tail daemon logs
* [obey models](../obey_models/)	 - Inspect the models this node can run
* [obey observe](../obey_observe/)	 - Observe recent and live session activity
* [obey ping](../obey_ping/)	 - Check if the daemon is running
* [obey plugins](../obey_plugins/)	 - List discovered obey plugins on PATH
* [obey providers](../obey_providers/)	 - List configured providers
* [obey run](../obey_run/)	 - Create a session and run one operator prompt
* [obey serve](../obey_serve/)	 - Start the daemon
* [obey service](../obey_service/)	 - Supervise the daemon with the operating system service manager
* [obey session](../obey_session/)	 - Manage agent sessions
* [obey socket-path](../obey_socket-path/)	 - Print the resolved daemon socket path
* [obey state](../obey_state/)	 - Inspect daemon campaign state
* [obey status](../obey_status/)	 - Show daemon status
* [obey stop](../obey_stop/)	 - Stop the daemon
* [obey top](../obey_top/)	 - Live session cockpit for the current campaign
* [obey turn](../obey_turn/)	 - Inspect and recover durable turns
* [obey usage](../obey_usage/)	 - View per-agent resource usage
* [obey version](../obey_version/)	 - Show version information
* [obey wrap](../obey_wrap/)	 - Run an interactive command with an Obey-owned PTY
