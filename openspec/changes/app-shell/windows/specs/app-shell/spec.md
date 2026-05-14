# Windows Spec: app-shell

## ADDED Requirements

### Requirement: Window is frameless with custom drag support
`MainWindow` SHALL set `WindowStyle="None"` and `AllowsTransparency="True"`. A `WindowChrome` with `CaptionHeight="50"` SHALL provide a drag region at the top. `ResizeBorderThickness="5"` SHALL allow resizing.

#### Scenario: Window can be dragged
- **WHEN** the user clicks and drags within the top 50px of the window
- **THEN** the window moves with the cursor

#### Scenario: Window can be resized
- **WHEN** the user drags the window edge
- **THEN** the window resizes

### Requirement: Window has rounded corners
An outer `Border` with `CornerRadius="12"` and `ClipToBounds="True"` SHALL clip all child content to rounded corners.

#### Scenario: Rounded corners visible
- **WHEN** the application launches
- **THEN** all four corners of the window are rounded with radius 12

### Requirement: Three screens share the same space via Visibility toggling
`MenuScreen`, `MediaScreen`, and `SuccessScreen` SHALL be placed in the same `Grid` cell. At any given time, exactly one SHALL have `Visibility=Visible`; the others SHALL be `Collapsed`.

#### Scenario: Initial state shows MenuScreen
- **WHEN** the application launches
- **THEN** `MenuScreen.Visibility == Visible`
- **THEN** `MediaScreen.Visibility == Collapsed`
- **THEN** `SuccessScreen.Visibility == Collapsed`

### Requirement: IMediaService is constructed and stored at startup
The `MainWindow` constructor SHALL instantiate `MediaService` and assign it to `_mediaService: IMediaService`.

#### Scenario: MediaService available after construction
- **WHEN** `MainWindow` is constructed
- **THEN** `_mediaService` is a non-null `MediaService` instance

### Requirement: Global KeyDown handler is registered
The constructor SHALL attach `MainWindow_KeyDown` to the window's `KeyDown` event.

#### Scenario: KeyDown fires on key press
- **WHEN** any key is pressed while the window is focused
- **THEN** `MainWindow_KeyDown` is invoked
