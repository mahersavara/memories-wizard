# setup-screen

## Why
Before sorting can begin, the user must select a source media folder and a destination folder for kept files. The setup screen collects this configuration and provides live feedback on discovered media count.

## What Changes
- New setup/home screen with source folder picker
- New destination folder picker
- Scan subfolders toggle with live media count preview
- "Begin Sorting" button with validation requiring both folders to be selected

## Non-Goals
- No actual file scanning or media loading (that is media-scanning)
- No media display or sorting logic

## Capabilities

### New Capabilities
- `setup-screen` — Windows, macOS: folder configuration UI with live media count feedback

### Modified Capabilities
*(none)*

## Impact
Populates the app-shell's Menu screen with folder configuration and session initialization controls.
