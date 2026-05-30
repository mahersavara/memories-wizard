# Spec: app-shell

## ADDED Requirements

### Requirement: App shell supports custom chrome interactions
The primary app window SHALL support drag, resize, and standard window controls through a custom shell layout.

#### Scenario: Window can be dragged
- **WHEN** the user drags inside the shell drag region
- **THEN** the window moves with the cursor

#### Scenario: Window can be resized
- **WHEN** the user drags the window edge
- **THEN** the window resizes

### Requirement: App shell has rounded corners
The app window SHALL render rounded corners while preserving visual clipping alignment.

#### Scenario: Rounded corners visible
- **WHEN** the application launches
- **THEN** all four corners of the window appear rounded

### Requirement: Setup, review, and summary views share one content region
The setup view, media review view, and summary view SHALL occupy the same content region. Exactly one view SHALL be active at a time.

#### Scenario: Initial state shows setup view
- **WHEN** the application launches
- **THEN** the setup view is active
- **THEN** the media review view is inactive
- **THEN** the summary view is inactive

### Requirement: Media service is initialized at startup
On app startup, the media service dependency SHALL be created and stored for later use.

#### Scenario: MediaService available after construction
- **WHEN** the app shell is initialized
- **THEN** a non-null media service is available

### Requirement: Global keyboard input is handled in the app shell
The app shell SHALL register a global key input handler while focused.

#### Scenario: KeyDown fires on key press
- **WHEN** any key is pressed while the window is focused
- **THEN** the app shell key handler is invoked

### Requirement: Custom title bar provides standard window controls
A title bar row SHALL include minimize, maximize or restore, and close controls. These controls SHALL remain interactive within the drag region.

#### Scenario: Minimize button minimises the window
- **WHEN** the user clicks the minimize control
- **THEN** the window enters minimized state

#### Scenario: Maximize button maximises and updates icon
- **WHEN** the user clicks the Maximize button while the window is in Normal state
- **THEN** the window enters maximized state
- **THEN** the control icon updates to reflect restore action

#### Scenario: Restore button restores and updates icon
- **WHEN** the user clicks the Maximize/Restore button while the window is Maximized
- **THEN** the window returns to normal state
- **THEN** the control icon updates to reflect maximize action

#### Scenario: Close button closes the window
- **WHEN** the user clicks the close control
- **THEN** the application window closes
