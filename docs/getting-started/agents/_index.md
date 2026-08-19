---
title: "Set up with your agent"
weight: 14
---

Festival is files and two CLIs. It works with any agent that can run shell commands and read files, which is nearly all of them. There is no plugin to install for the core loop: the agent runs `fest next`, reads the task document it prints, does the work, and runs `fest task completed` and `fest commit`. Everything else on this page is about making that loop shorter to reach.

## Skills for every agent

Festival publishes 12 skills that teach an agent the campaign and festival vocabulary: how to navigate a campaign, how to commit inside one, how to plan a festival, and how to execute one. They are plain `SKILL.md` files in the open agent-skills layout, so one command installs them into most agents:

```bash
npx skills add Obedience-Corp/festival
```

That reaches the agents behind [skills.sh](https://skills.sh/Obedience-Corp/festival). Add `--list` to see the skill names before installing, or `--all` to take the whole set.

## Per-agent guides

Some agents have their own skill channels and their own conventions. These guides cover the setup path end to end for each one.

- [Hermes Agent](hermes/): install the binaries, add the Festival skills tap, and run the loop from a campaign root.

More guides will follow. If your agent is not listed, install the binaries from the [installation page](../installation/), run `camp init`, and start your agent from the campaign root. The [quickstart](../quickstart/) is agent agnostic.
