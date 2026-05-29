# OpenSpec Agent Orchestration

Multi-agent system for implementing OpenSpec changes in dependency order with parallel execution support.

## Architecture

```
User invokes openspec-orchestrator
         │
         ▼
  ┌──────────────────────────┐
  │  openspec-orchestrator   │  Reads dependency.md, plans batches
  │  Tools: agent, read,     │
  │         execute          │
  └──────┬───────────────────┘
         │ Spawns subagents per batch
         ▼
  ┌──────────────────────────────────────────────┐
  │  Batch 1 (parallel)                          │
  │  ┌──────────────────┐  ┌──────────────────┐  │
  │  │ openspec-apply   │  │ openspec-apply   │  │
  │  │ project-setup    │  │ app-shell        │  │
  │  └──────────────────┘  └──────────────────┘  │
  └──────────────────────────────────────────────┘
         │ Both complete
         ▼
  ┌──────────────────────────────────────────────┐
  │  Batch 2 (parallel)                          │
  │  ┌──────────────────┐  ┌──────────────────┐  │
  │  │ openspec-apply   │  │ openspec-apply   │  │
  │  │ setup-screen     │  │ media-scanning   │  │
  │  └──────────────────┘  └──────────────────┘  │
  └──────────────────────────────────────────────┘
         │ ... continue through all batches ...
         ▼
  ┌──────────────────────────┐
  │  openspec-archive         │  Handoff: archives all done changes
  │  Tools: execute, read     │
  └──────────────────────────┘
```

## Agents

| Agent | File | Role | Invocation |
|-------|------|------|------------|
| `openspec-orchestrator` | `openspec-orchestrator.agent.md` | Reads dependency.md, plans batches, spawns apply subagents | User-invocable (chat picker) |
| `openspec-apply` | `openspec-apply.agent.md` | Implements all tasks for ONE change on ONE platform | Subagent only (orchestrator spawns) |
| `openspec-archive` | `openspec-archive.agent.md` | Archives completed changes | Subagent only (orchestrator handoff) |

## Dependency Resolution

The orchestrator reads `openspec/changes/dependency.md` and builds execution batches:

| Batch | Changes | Dependencies |
|-------|---------|-------------|
| 1 | `project-setup`, `app-shell` | None (parallel-safe) |
| 2 | `setup-screen`, `media-scanning` | Both depend on Batch 1 |
| 3 | `media-viewer` | Depends on Batch 2 |
| 4 | `swipe-decisions`, `video-playback` | Both depend on `media-viewer` |
| 5 | `decision-processing` | Depends on `swipe-decisions` |
| 6 | `session-summary` | Depends on `decision-processing` |

Changes within the same batch have no dependencies on each other and run in parallel.

## Usage

### Full pipeline
```
User: "Build everything for macOS"
→ Opens orchestrator agent
→ Spawns all changes in dependency order
→ After all done, handoff to archive
```

### Single change
```
User: "Implement project-setup for windows"
→ Opens orchestrator OR directly invokes openspec-apply
→ Implements one change
```

## VS Code Agent Capabilities Used

| Capability | How It's Used |
|------------|---------------|
| **Subagents** | `openspec-apply` runs as context-isolated subagent per change |
| **Parallel execution** | Multiple `openspec-apply` subagents run simultaneously in same batch |
| **Handoffs** | After all changes done, orchestrator shows "Archive All" handoff button |
| **Tool restrictions** | `openspec-apply` only has read/edit/search/execute; no agent spawning |
| **User-invocable: false** | Apply and archive agents are hidden from chat picker |
| **agents: [...]** | Orchestrator can only spawn openspec-apply and openspec-archive subagents |

## Limitations

1. **Subagents are one-shot**: Each `openspec-apply` subagent runs in a fresh context per invocation. State does not persist across calls, but file changes are visible on disk, which satisfies dependency requirements.

2. **No inter-subagent communication**: Subagents cannot communicate with each other. Dependencies are satisfied by implementation order only (Batch N+1 reads files written by Batch N).

3. **Single orchestrator session**: All batches run within one orchestrator chat session. For very large changesets, the chat may hit context limits. This is mitigated by subagent context isolation -- only summaries enter the orchestrator context.

4. **No programmatic session archive**: VS Code has no API to archive chat sessions. The archive agent moves files to `openspec/changes/archive/` on disk only. The orchestrator chat session remains and must be manually archived via VS Code session management.
