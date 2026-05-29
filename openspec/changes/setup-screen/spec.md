# Spec: setup-screen

## ADDED Requirements

### Requirement: User can select source folder via native dialog
The system SHALL open a native folder picker when the user selects source folder action and display the chosen path in the source field.

#### Scenario: Source folder selected
- **WHEN** user clicks the source "Select" button
- **THEN** a native folder picker opens
- **WHEN** user confirms a folder
- **THEN** the folder path appears in source field and media count updates immediately

### Requirement: User can select destination folder via native dialog
The system SHALL open a native folder picker when the user selects destination folder action and display the chosen path in the destination field.

#### Scenario: Destination folder selected
- **WHEN** user clicks the destination "Select" button
- **THEN** a native folder picker opens
- **WHEN** user confirms a folder
- **THEN** the folder path appears in destination field

### Requirement: Scan subfolders toggle controls recursive discovery
A recursive toggle (default enabled) SHALL control whether media scanning includes subfolders. Changing the toggle SHALL immediately refresh media count display.

#### Scenario: Toggle recursive off
- **WHEN** recursive toggle is disabled
- **THEN** media count reflects top-level directory only

#### Scenario: Toggle recursive on
- **WHEN** recursive toggle is enabled
- **THEN** media count includes files from all subdirectories

### Requirement: Live media count is displayed after source selection
After source selection or recursive toggle change, the app SHALL display the number of supported media files found.

#### Scenario: Count shows after source selection
- **WHEN** a source folder is selected
- **THEN** media count label reflects the actual count

### Requirement: Start button validates both folders are selected
Clicking begin sorting SHALL show a warning if source or destination is missing. If both are configured, the app SHALL initialize queue and transition to review view.

#### Scenario: Start with missing folder
- **WHEN** user clicks "Begin Sorting" with source or destination not selected
- **THEN** a warning notification with text "Please select both folders." is shown
- **THEN** the screen does not navigate away

#### Scenario: Start with both folders selected
- **WHEN** user clicks "Begin Sorting" with both folders selected
- **THEN** media queue is initialized and review view becomes visible
