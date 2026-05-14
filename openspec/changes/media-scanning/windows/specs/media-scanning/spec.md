# Windows Spec: media-scanning

## ADDED Requirements

### Requirement: IMediaService defines the scanning contract
A `IMediaService` interface SHALL declare `GetMediaFiles(string sourcePath, bool recursive = true)` returning `MediaScanResult`.

#### Scenario: Interface is implemented
- **WHEN** `MediaService` is instantiated as `IMediaService`
- **THEN** all interface members are satisfied without compilation errors

### Requirement: MediaScanResult separates media from unsupported files
`MediaScanResult` SHALL expose two `List<string>` properties: `MediaFiles` and `UnsupportedFiles`, both initialised to empty lists.

#### Scenario: Empty scan on missing path
- **WHEN** `GetMediaFiles` is called with a non-existent path
- **THEN** both `MediaFiles` and `UnsupportedFiles` are empty

### Requirement: MediaService scans for supported extensions only
`MediaService.GetMediaFiles` SHALL include only files with extensions: `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.mp4`, `.mov`, `.wmv`, `.avi` (case-insensitive). All other files go to `UnsupportedFiles`.

#### Scenario: Mixed directory scan
- **WHEN** a directory contains `photo.JPG`, `video.mp4`, `doc.pdf`, `notes.txt`
- **THEN** `MediaFiles` contains `photo.JPG` and `video.mp4`
- **THEN** `UnsupportedFiles` contains `doc.pdf` and `notes.txt`

### Requirement: Hidden files (dot-prefix) are excluded
Files whose name starts with `.` SHALL be excluded from both `MediaFiles` and `UnsupportedFiles`.

#### Scenario: Hidden file skipped
- **WHEN** a directory contains `.DS_Store` and `photo.jpg`
- **THEN** only `photo.jpg` appears in `MediaFiles`; `.DS_Store` is not in either list

### Requirement: Recursive flag controls subdirectory traversal
When `recursive = true`, `GetMediaFiles` SHALL use `SearchOption.AllDirectories`. When `recursive = false`, it SHALL use `SearchOption.TopDirectoryOnly`.

#### Scenario: Recursive scan includes subdirectory files
- **WHEN** `GetMediaFiles` is called with `recursive = true` on a directory containing a subdirectory with media files
- **THEN** files from the subdirectory appear in `MediaFiles`

#### Scenario: Non-recursive scan excludes subdirectory files
- **WHEN** `GetMediaFiles` is called with `recursive = false`
- **THEN** only files in the top-level directory appear in the result

### Requirement: Decision enum defines three sort outcomes
A `Decision` enum SHALL declare: `Keep`, `Skip`, `Trash`.

#### Scenario: All enum values accessible
- **WHEN** code references `Decision.Keep`, `Decision.Skip`, `Decision.Trash`
- **THEN** all three values compile and are distinct
