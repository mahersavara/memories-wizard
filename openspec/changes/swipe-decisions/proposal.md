# swipe-decisions

## Why
The core sorting experience relies on fluid, gesture-driven decisions. Users should be able to drag a media card left (skip), right (keep), or down (trash) as with swipe-based apps, with real-time visual feedback and keyboard alternatives.

## What Changes
- Drag gesture on the media card translates and tilts the card in real-time
- Direction indicator overlay (KEEP / SKIP / TRASH) fades in proportionally to drag distance
- Release below threshold springs the card back to centre
- Release above threshold animates the card off-screen (with concurrent tilt-doubling rotation) and fires the decision
- Any in-progress card animation is cancelled immediately when a new drag begins
- Keyboard shortcuts: → Keep, ← Skip, ↓ Trash

## Non-Goals
- No file operations (covered in decision-processing)
- No video-specific interaction differences

## Capabilities

### New Capabilities
- `swipe-decisions` — Windows, macOS: drag gesture, visual feedback, spring-back, fly-off animation, and keyboard shortcuts

### Modified Capabilities
*(none)*

## Impact
Extends the media-viewer card with gesture input and visual feedback, and connects to decision-processing to execute the chosen action.
