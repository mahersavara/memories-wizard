# app-shell

## Why
The application needs a host window that provides a modern frameless look while still supporting standard window management (drag, resize, close). A single window with three swappable screen panels avoids the overhead of multiple windows and keeps navigation simple.

## What Changes
- Single application window with frameless styling and native drag and resize support
- Rounded corner clipping applied to the entire window surface
- Three named screen panels (Menu, Media, Summary) hosted in the same container
- Only one screen visible at a time via visibility toggling
- Media service injected at startup; global keyboard input handler registered

## Non-Goals
- No multi-window navigation
- No minimize-to-tray

## Capabilities

### New Capabilities
- `app-shell` — Windows, macOS: frameless window host with screen panel switching

### Modified Capabilities
*(none)*

## Impact
Introduces the host window and screen container that all subsequent screen changes (setup-screen, media-viewer, session-summary) populate.
