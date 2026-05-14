# Windows Spec: setup-screen

## ADDED Requirements

### Requirement: User can select source folder via native dialog
The system SHALL open a native `OpenFolderDialog` when the source "Select" button is clicked and display the chosen path in the read-only `TxtSourcePath` text box.

#### Scenario: Source folder selected
- **WHEN** user clicks the source "Select" button
- **THEN** an `OpenFolderDialog` opens
- **WHEN** user confirms a folder
- **THEN** the folder path appears in `TxtSourcePath` and the media count updates immediately

### Requirement: User can select destination folder via native dialog
The system SHALL open a native `OpenFolderDialog` when the destination "Select" button is clicked and display the chosen path in the read-only `TxtDestPath` text box.

#### Scenario: Destination folder selected
- **WHEN** user clicks the destination "Select" button
- **THEN** an `OpenFolderDialog` opens
- **WHEN** user confirms a folder
- **THEN** the folder path appears in `TxtDestPath`

### Requirement: Scan subfolders toggle controls recursive discovery
A `ChkRecursive` checkbox (default: checked) SHALL control whether media scanning is recursive. Changing the checkbox SHALL immediately refresh the media count display.

#### Scenario: Toggle recursive off
- **WHEN** `ChkRecursive` is unchecked
- **THEN** `TxtMediaCount` updates to show the count from top-level directory only

#### Scenario: Toggle recursive on
- **WHEN** `ChkRecursive` is checked
- **THEN** `TxtMediaCount` updates to include files from all subdirectories

### Requirement: Live media count is displayed after source selection
After a source folder is selected or the recursive toggle changes, `TxtMediaCount` SHALL display the number of supported media files found (e.g., "12 media files found.").

#### Scenario: Count shows after source selection
- **WHEN** a source folder is selected
- **THEN** `TxtMediaCount` shows "N media files found." reflecting the actual count

### Requirement: Start button validates both folders are selected
Clicking "Begin Sorting" SHALL show a warning `MessageBox` if either `_sourcePath` or `_destPath` is empty. If both are set, it SHALL proceed to initialise the media queue and transition to `MediaScreen`.

#### Scenario: Start with missing folder
- **WHEN** user clicks "Begin Sorting" with source or destination not selected
- **THEN** a warning MessageBox with text "Please select both folders." is shown
- **THEN** the screen does not navigate away

#### Scenario: Start with both folders selected
- **WHEN** user clicks "Begin Sorting" with both folders selected
- **THEN** `InitializeMediaQueue()` is called and `MediaScreen` becomes visible
