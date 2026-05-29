# Spec: video-playback

## ADDED Requirements

### Requirement: Video files auto-play on load
When the active media item is a supported video file, the app SHALL load and auto-play video preview, show video controls, and hide image preview.

#### Scenario: Video file loads and plays
- **WHEN** a supported video file is loaded
- **THEN** video preview is visible and playing
- **THEN** image preview is hidden and video controls are visible

### Requirement: Video loops automatically
When video playback reaches end, playback SHALL restart from the beginning.

#### Scenario: Video reaches end
- **WHEN** the video plays to the end
- **THEN** it restarts from the beginning without user interaction

### Requirement: Seek slider tracks playback position
The seek control and time display SHALL update during playback at short regular intervals. Automatic updates SHALL pause while user is actively dragging seek control.

#### Scenario: Seek slider updates during playback
- **WHEN** the video is playing
- **THEN** seek position advances and time display updates continuously

#### Scenario: Timer does not update during user drag
- **WHEN** user is dragging seek control
- **THEN** the timer tick does not override the slider value

### Requirement: User can seek by dragging the seek slider
Dragging seek control SHALL enable active seeking mode, update playback position during drag, and apply final playback position on release.

#### Scenario: User drags seek slider
- **WHEN** user drags seek control to 30 seconds
- **THEN** on release, playback position is set to 30 seconds

#### Scenario: Position updates live during drag
- **WHEN** user drags seek control while video is playing
- **THEN** playback position updates continuously while dragging

### Requirement: Volume slider controls playback volume
Volume control SHALL set playback volume over normalized range from 0 to 1, defaulting to 0.5.

#### Scenario: Volume adjusted
- **WHEN** user sets volume control to 0.8
- **THEN** playback volume becomes 0.8

### Requirement: Speed selector changes playback rate
Speed selector SHALL provide 0.5x, 0.75x, 1.0x default, 1.25x, 1.5x, and 2.0x options. Playback rate SHALL update on selection change.

#### Scenario: Speed set to 1.5x
- **WHEN** user selects 1.5x speed
- **THEN** playback runs at 1.5x

### Requirement: Playback errors are surfaced as a warning dialog
Playback failures SHALL surface as a warning dialog containing error details.

#### Scenario: Unsupported video codec
- **WHEN** playback fails due to unsupported format or decode error
- **THEN** a warning dialog shows the error message

### Requirement: MediaOpened initialises seek range, starts playback timer, and applies speed
When video is opened successfully, the app SHALL initialize seek range to full duration, start playback update timer, and apply current speed selection immediately.

#### Scenario: Seek slider range matches video duration on open
- **WHEN** a new video is loaded
- **THEN** seek range equals full video duration

#### Scenario: Playback timer starts on open
- **WHEN** a new video is loaded
- **THEN** playback timer starts and seek plus time displays begin updating

#### Scenario: Speed preserved across video changes
- **WHEN** user sets speed to 1.5x and then swipes to the next video
- **THEN** the new video starts playing at 1.5x without requiring the user to reselect the speed

### Requirement: Video resources are deactivated when leaving video preview mode
When the active item is not a video, video playback resources SHALL be deactivated, the periodic playback update timer SHALL stop, and stale video source references SHALL be cleared.

#### Scenario: Transition from video item to image item
- **WHEN** user advances from a video item to a non-video item
- **THEN** video playback is stopped
- **THEN** video update timer is stopped
- **THEN** video source reference is cleared

## MODIFIED Requirements

### Requirement: Media viewer routes video files to video preview behavior
The media viewer SHALL detect supported video extensions and route rendering through video preview behavior instead of image preview behavior.

#### Scenario: Video extension detected
- **WHEN** the current file has extension `.mp4`, `.mov`, `.wmv`, or `.avi`
- **THEN** video preview is used for display and image preview is hidden
