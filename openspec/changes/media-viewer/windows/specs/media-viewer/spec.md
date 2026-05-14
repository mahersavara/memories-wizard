# Windows Spec: media-viewer

## ADDED Requirements

### Requirement: Media queue is initialised from scan result
`InitializeMediaQueue` SHALL call `_mediaService.GetMediaFiles` with the configured source path and recursive flag, populate `_mediaFiles`, and show an informational `MessageBox` if the result is empty.

#### Scenario: Empty scan result
- **WHEN** the source directory contains no supported media files
- **THEN** a MessageBox with "No media files found." is shown
- **THEN** the app remains on `MenuScreen`

#### Scenario: Non-empty scan transitions to MediaScreen
- **WHEN** the source directory contains at least one supported media file
- **THEN** `MediaScreen` becomes visible and `MenuScreen` is collapsed
- **THEN** `TxtTotalCount` shows " / N" where N is the total file count

### Requirement: Images are rendered with memory-optimised BitmapImage
For image files, the system SHALL create a `BitmapImage` with `CacheOption = BitmapCacheOption.OnLoad` and `DecodePixelWidth = 1000` to limit RAM usage.

#### Scenario: Image loads without holding file handle
- **WHEN** an image file is loaded into `ImgPreview`
- **THEN** the file handle is released immediately after load (OnLoad cache)
- **THEN** the image is decoded at most 1000 pixels wide

### Requirement: Filename and position counter are displayed
`TxtFileName` SHALL show the base filename (no path). `TxtCurrentIndex` SHALL show the 1-based current index. `TxtTotalCount` SHALL show " / N".

#### Scenario: Counter updates on each file load
- **WHEN** media at index 3 out of 10 is loaded
- **THEN** `TxtFileName` shows the file's base name
- **THEN** `TxtCurrentIndex` shows "3" and `TxtTotalCount` shows " / 10"

### Requirement: User can jump to a specific index by typing and pressing Enter
`TxtCurrentIndex` SHALL be an editable text box. On Enter key press, if the value is a valid 1-based integer within range, the viewer SHALL navigate to that file. Invalid values SHALL restore the current index text.

#### Scenario: Valid jump
- **WHEN** user types "5" in `TxtCurrentIndex` and presses Enter
- **THEN** the viewer loads the 5th media file

#### Scenario: Out-of-range jump
- **WHEN** user types "999" (beyond total) and presses Enter
- **THEN** `TxtCurrentIndex` is restored to the current index value

### Requirement: Advancing past the last file triggers session summary
`ShowNextMedia` SHALL increment `_currentIndex` and call `ShowSuccess` when the index reaches or exceeds the total file count.

#### Scenario: Last file advanced
- **WHEN** the user makes a decision on the last file in the queue
- **THEN** `SuccessScreen` is shown and `MediaScreen` is collapsed

### Requirement: Transform state resets on each file load
On `LoadCurrentMedia`, translation (`X`, `Y`) and rotation (`Angle`) transforms on `MediaContainer` SHALL be reset to zero and the decision indicator SHALL have opacity 0.

#### Scenario: No residual animation on new file
- **WHEN** a new media file is loaded
- **THEN** the card appears centered with no tilt and no decision label visible
