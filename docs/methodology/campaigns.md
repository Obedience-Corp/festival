# Campaigns

<!-- TODO: Document campaign concept, workspace structure, and camp CLI integration -->

Campaigns are the top-level organizational unit in the Festival Methodology hierarchy. A campaign is a workspace that contains multiple related projects and their associated festivals.

## What is a Campaign?

A campaign represents a cohesive body of work — a product, a platform, or a collection of related projects that share a common goal.

## Campaign Structure

```
my-campaign/
├── projects/          # Project repositories
├── festivals/         # Festival planning workspace
│   ├── planning/      # Festivals being designed
│   ├── active/        # Currently executing
│   ├── ready/         # Prepared, awaiting execution
│   └── dungeon/       # Terminal statuses
├── workflow/          # Workflow management
└── docs/              # Documentation
```

## Managing Campaigns

The `camp` CLI manages campaign-level operations. See the [camp CLI reference](../cli-reference/camp/index.md).
