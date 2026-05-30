# Spec: media-viewer

## ADDED Requirements

### Requirement: Media queue is initialised from scan result
When a session starts, the app SHALL request scan results for the configured source and recursion setting, populate the review queue, and notify the user if no media is found.

#### Scenario: Empty scan result
- **WHEN** the source directory contains no supported media files
- **THEN** a user notification with "No media files found." is shown
- **THEN** the app remains on the setup view

#### Scenario: Non-empty scan transitions to review view
- **WHEN** the source directory contains at least one supported media file
- **THEN** the app transitions from setup view to media review view
- **THEN** the total item count is displayed

### Requirement: Image rendering uses memory-conscious decoding
For image files, the app SHALL decode media using a memory-conscious strategy that avoids unnecessary memory growth and long-lived file locks.

#### Scenario: Image loads without holding file handle
- **WHEN** an image file is loaded for preview
- **THEN** the source file handle is released after load
- **THEN** decoded image size is constrained for efficient preview

### Requirement: Filename and position counter are displayed
The review UI SHALL display the current file name, 1-based current position, and total item count.

#### Scenario: Counter updates on each file load
- **WHEN** media at index 3 out of 10 is loaded
- **THEN** the displayed file name matches the active media
- **THEN** the displayed position and total are updated to 3 and 10

### Requirement: User can jump to a specific index by typing and pressing Enter
The position display SHALL be editable. On Enter, valid in-range 1-based values SHALL navigate to that media item. Invalid values SHALL restore the current displayed position.

#### Scenario: Valid jump
- **WHEN** user enters 5 and presses Enter
- **THEN** the viewer loads the 5th media file

#### Scenario: Out-of-range jump
- **WHEN** user types "999" (beyond total) and presses Enter
- **THEN** the position display is restored to the active index value

### Requirement: Keyboard focus returns to media interaction after index jump
After a successful index jump, keyboard focus SHALL return to the media interaction surface so swipe shortcuts remain available without extra clicks.

#### Scenario: Focus handoff after valid jump
- **WHEN** user enters a valid index and navigation completes
- **THEN** media interaction surface is focused
- **THEN** keyboard decision shortcuts are immediately available

### Requirement: Advancing past the last file triggers session summary
When advancing would move past the final item, the app SHALL transition from review view to summary view.

#### Scenario: Last file advanced
- **WHEN** the user makes a decision on the last file in the queue
- **THEN** the summary view is shown and the review view is hidden

### Requirement: Transform state resets on each file load
Each newly loaded media item SHALL reset translation, rotation, and decision indicator visibility to neutral defaults.

#### Scenario: No residual animation on new file
- **WHEN** a new media file is loaded
- **THEN** the card appears centered with no tilt and no decision label visible
