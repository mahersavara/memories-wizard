# media-viewer

## Why
Once the media queue is populated, the user needs to view media files one at a time in a card-style viewer. The viewer manages the queue index, renders images efficiently, and shows navigational context (filename and position counter).

## What Changes
- Media queue initialisation from scan results with empty-queue guard
- Image rendering optimised for display dimensions
- Filename label and editable position counter (current / total)
- Jump-to-index: user can type a number and navigate directly to that position
- Queue advancement: moving to next item or triggering session summary when exhausted

## Non-Goals
- No video playback (covered in video-playback)
- No swipe/decision input (covered in swipe-decisions)
- No file operations (covered in decision-processing)

## Capabilities

### New Capabilities
- `media-viewer` — Windows, macOS: media queue, image display, counter, and direct navigation

### Modified Capabilities
*(none)*

## Impact
Populates the app-shell's Media screen with the card viewer UI and wires the media queue from media-scanning results.
