# Spec: media-scanning

## ADDED Requirements

### Requirement: Media scanning service defines a stable contract
The media scanning service SHALL expose an operation that returns a scan result for a source folder, with optional recursive traversal.

#### Scenario: Interface is implemented
- **WHEN** the app initializes the media scanning service
- **THEN** the required contract is fully implemented

### Requirement: MediaScanResult separates media from unsupported files
The scan result SHALL include two collections: supported media files and unsupported files. Both collections SHALL default to empty.

#### Scenario: Empty scan on missing path
- **WHEN** scanning is requested for a non-existent path
- **THEN** both collections are empty

### Requirement: Scanner includes only supported media extensions
The scanner SHALL include only files with these extensions (case-insensitive): .jpg, .jpeg, .png, .gif, .bmp, .mp4, .mov, .wmv, .avi. All other files SHALL be classified as unsupported.

#### Scenario: Mixed directory scan
- **WHEN** a directory contains supported and unsupported file types
- **THEN** supported files appear in the media collection
- **THEN** unsupported files appear in the unsupported collection

### Requirement: Hidden files (dot-prefix) are excluded
Files whose name starts with a dot SHALL be excluded from both result collections.

#### Scenario: Hidden file skipped
- **WHEN** a directory contains dot-prefixed entries and visible media files
- **THEN** dot-prefixed entries do not appear in either collection
- **THEN** visible supported files still appear in the media collection

### Requirement: Recursive flag controls subdirectory traversal
When recursive mode is enabled, scanning SHALL include subdirectories. When disabled, scanning SHALL include only top-level files.

#### Scenario: Recursive scan includes subdirectory files
- **WHEN** recursive scanning is enabled
- **THEN** media files in subdirectories appear in results

#### Scenario: Non-recursive scan excludes subdirectory files
- **WHEN** recursive scanning is disabled
- **THEN** only top-level files appear in results

### Requirement: Decision enum defines three sort outcomes
The decision model SHALL define three outcomes: Keep, Skip, and Trash.

#### Scenario: All enum values accessible
- **WHEN** decision outcomes are used in sorting flow
- **THEN** all three outcomes are available and distinct
