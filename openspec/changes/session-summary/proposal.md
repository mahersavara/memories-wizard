# session-summary

## Why
After sorting all files (or choosing to stop early), users need a clear report of what happened — how many files were kept, skipped, trashed, or filtered as non-media. They also need a shortcut to open the destination folder and a way to start a new session.

## What Changes
- New summary screen displayed when the queue is exhausted or the user ends the session early
- Summary text showing kept, skipped, trashed, and non-media file counts
- "Open Destination" action opens the destination folder in the platform file browser
- "Back to Menu" resets to the setup screen for a new session
- "Complete Now" button in the media screen allows early session termination

## Non-Goals
- No per-file breakdown or undo
- No export of the session log

## Capabilities

### New Capabilities
- `session-summary` — Windows, macOS: end-of-session screen with stats, destination access, and session reset

### Modified Capabilities
*(none)*

## Impact
Closes the sorting loop by consuming the session tracking data from decision-processing and presenting it in the app-shell's Summary screen.
