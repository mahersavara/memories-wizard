# media-scanning

## Why
The app needs to discover which files in a directory are supported media before the user can begin sorting. A dedicated scanning service separates file-system logic from UI concerns and makes the scanning behaviour testable and portable.

## What Changes
- Scanning service interface and implementation for discovering media files in a directory
- Scan result data structure separating media files from unsupported files
- Decision domain type (Keep, Skip, Trash) shared across the application
- Hidden files (dot-prefix) are silently excluded from results
- Supported image and video formats defined as the scan filter

## Non-Goals
- No file move or delete operations (covered in decision-processing)
- No UI — purely a service/domain layer

## Capabilities

### New Capabilities
- `media-scanning` — Windows, macOS: directory scanning service returning categorised file lists

### Modified Capabilities
*(none)*

## Impact
Provides the file list consumed by media-viewer and the decision domain type used by swipe-decisions and decision-processing.
