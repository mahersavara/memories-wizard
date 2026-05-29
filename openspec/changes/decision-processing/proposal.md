# decision-processing

## Why
When a user swipes or presses a key to keep, skip, or trash a file, the app must execute the corresponding file operation reliably. Media files can be temporarily locked by the preview engine, requiring retry logic. Session tracking enables the summary screen.

## What Changes
- Keep decision: moves the file to the destination folder; creates the folder if missing; adds a unique prefix on filename collision
- Trash decision: sends the file to the system recycle bin; falls back to a local `.trash` subfolder if unavailable
- Skip decision: records the file without any file system operation
- Media sources (video and image) are explicitly released before any file operation to prevent OS file-lock errors
- Retry logic: retries transient I/O errors to handle media engine file locks
- Four session tracking lists accumulate outcomes (kept, skipped, trashed, unsupported) for the summary screen
- Session tracking lists are reset at the start of each new session to ensure fresh counts

## Non-Goals
- No undo / undo history
- No batch operations

## Capabilities

### New Capabilities
- `decision-processing` — Windows, macOS: file operations, retry logic, and session tracking per decision

### Modified Capabilities
*(none)*

## Impact
Completes the swipe-decisions loop by executing the chosen file operation and populating the session tracking data consumed by session-summary.
