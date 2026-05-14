# video-playback

## Why
The media library may contain video files alongside photos. Users need inline video playback with basic controls so they can make an informed keep/skip/trash decision without opening an external player.

## What Changes
- Video renderer displays video files inside the media card; auto-plays and loops on completion
- Controls overlay with seek slider, volume slider, and playback speed selector
- Periodic timer syncs the seek position and elapsed/total time display during playback
- Seek slider distinguishes user drag from programmatic updates to avoid feedback loops
- Playback errors are surfaced as a user-facing warning dialog

## Non-Goals
- No audio-only file support
- No full-screen video mode
- No subtitle or chapter support

## Capabilities

### New Capabilities
- `video-playback` — Windows, macOS: inline video rendering, looping, and playback controls

### Modified Capabilities
- `media-viewer` — Windows, macOS: extended to handle video files in addition to images

## Impact
Extends media-viewer's current-media loading with a video rendering branch, keeping the existing image rendering path unchanged.
