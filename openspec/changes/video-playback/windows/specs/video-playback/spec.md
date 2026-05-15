# Windows Spec: video-playback

## ADDED Requirements

### Requirement: Video files auto-play on load
When `LoadCurrentMedia` detects a video extension (`.mp4`, `.mov`, `.wmv`, `.avi`), it SHALL set `VidPreview.Source`, call `VidPreview.Play()`, and make `VidControls` visible. `ImgPreview` SHALL be hidden.

#### Scenario: Video file loads and plays
- **WHEN** `LoadCurrentMedia` is called for a `.mp4` file
- **THEN** `VidPreview` is visible and playing; `ImgPreview` is collapsed; `VidControls` is visible

### Requirement: Video loops automatically
`VidPreview.MediaEnded` SHALL reset `VidPreview.Position` to `TimeSpan.Zero` to loop the video.

#### Scenario: Video reaches end
- **WHEN** the video plays to the end
- **THEN** it restarts from the beginning without user interaction

### Requirement: Seek slider tracks playback position
A `DispatcherTimer` with 200ms interval SHALL update `SldSeek.Value` and `TxtVidTime.Text` during playback. The timer SHALL not update while the user is dragging (`_isSeeking == true`).

#### Scenario: Seek slider updates during playback
- **WHEN** the video is playing
- **THEN** `SldSeek` advances and `TxtVidTime` shows `mm:ss / mm:ss` every ~200ms

#### Scenario: Timer does not update during user drag
- **WHEN** user is dragging `SldSeek`
- **THEN** the timer tick does not override the slider value

### Requirement: User can seek by dragging the seek slider
`SldSeek.DragStarted` SHALL set `_isSeeking = true`. `SldSeek.DragCompleted` SHALL set `_isSeeking = false` and apply `VidPreview.Position = TimeSpan.FromSeconds(SldSeek.Value)`.

#### Scenario: User drags seek slider
- **WHEN** user drags `SldSeek` to 30 seconds
- **THEN** on release, `VidPreview.Position` is set to 30 seconds

### Requirement: Volume slider controls playback volume
`SldVolume` (range 0–1, default 0.5) SHALL set `VidPreview.Volume` on `ValueChanged`.

#### Scenario: Volume adjusted
- **WHEN** user moves `SldVolume` to 0.8
- **THEN** `VidPreview.Volume` becomes 0.8

### Requirement: Speed selector changes playback rate
`CmbSpeed` ComboBox SHALL offer: `0.5x`, `0.75x`, `1.0x` (default), `1.25x`, `1.5x`, `2.0x`. On selection change, `VidPreview.SpeedRatio` SHALL be updated accordingly.

#### Scenario: Speed set to 1.5x
- **WHEN** user selects "1.5x" from `CmbSpeed`
- **THEN** `VidPreview.SpeedRatio == 1.5`

### Requirement: Playback errors are surfaced as a warning dialog
`VidPreview.MediaFailed` SHALL show a `MessageBox` with the error message.

#### Scenario: Unsupported video codec
- **WHEN** `MediaFailed` fires
- **THEN** a warning MessageBox shows the error message

### Requirement: Current speed setting is applied each time a video opens
`VidPreview_MediaOpened` SHALL call `ApplyCurrentSpeed()` so that the speed selected in `CmbSpeed` is applied immediately when a new video is loaded, not only when the user changes the selector.

#### Scenario: Speed preserved across video changes
- **WHEN** user sets speed to 1.5x and then swipes to the next video
- **THEN** the new video starts playing at 1.5x without requiring the user to reselect the speed

## MODIFIED Requirements

### Requirement: media-viewer — LoadCurrentMedia handles video files
`LoadCurrentMedia` SHALL detect video extensions and use the `VidPreview` path instead of `ImgPreview`.

#### Scenario: Video extension detected
- **WHEN** the current file has extension `.mp4`, `.mov`, `.wmv`, or `.avi`
- **THEN** `VidPreview` is used for display and `ImgPreview` is hidden
