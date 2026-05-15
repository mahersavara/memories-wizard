# Windows Spec: app-shell

## ADDED Requirements

### Requirement: Window is frameless with custom drag support
`MainWindow` SHALL set `WindowStyle="None"` and `AllowsTransparency="True"`. A `WindowChrome` with `CaptionHeight="50"` SHALL provide a drag region at the top. `ResizeBorderThickness="8"` SHALL allow resizing.

#### Scenario: Window can be dragged
- **WHEN** the user clicks and drags within the top 50px of the window
- **THEN** the window moves with the cursor

#### Scenario: Window can be resized
- **WHEN** the user drags the window edge
- **THEN** the window resizes

### Requirement: Window has rounded corners
An outer `Border` with `CornerRadius="30"` and `ClipToBounds="True"` SHALL clip all child content to rounded corners.

#### Scenario: Rounded corners visible
- **WHEN** the application launches
- **THEN** all four corners of the window are rounded with radius 30

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

### Requirement: Custom title bar provides Minimize, Maximize/Restore, and Close controls
A title bar row within the window chrome SHALL contain three buttons:
- **Minimize** (`—`): sets `WindowState = Minimized`.
- **Maximize/Restore** (`▢` / `❐`): toggles between `WindowState.Maximized` and `WindowState.Normal`; the button content SHALL update to reflect the current state (`▢` when normal, `❐` when maximised).
- **Close** (`✕`): calls `Close()`.
All three buttons SHALL be marked `WindowChrome.IsHitTestVisibleInChrome="True"` so they remain clickable inside the drag region.

#### Scenario: Minimize button minimises the window
- **WHEN** the user clicks the Minimize (`—`) button
- **THEN** `WindowState` becomes `Minimized`

#### Scenario: Maximize button maximises and updates icon
- **WHEN** the user clicks the Maximize button while the window is in Normal state
- **THEN** `WindowState` becomes `Maximized`
- **THEN** the button content changes to `❐`

#### Scenario: Restore button restores and updates icon
- **WHEN** the user clicks the Maximize/Restore button while the window is Maximized
- **THEN** `WindowState` returns to `Normal`
- **THEN** the button content changes back to `▢`

#### Scenario: Close button closes the window
- **WHEN** the user clicks the Close (`✕`) button
- **THEN** the application window closes
