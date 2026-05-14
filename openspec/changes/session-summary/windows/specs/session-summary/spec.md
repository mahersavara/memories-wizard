# Windows Spec: session-summary

## ADDED Requirements

### Requirement: SuccessScreen is shown when queue is exhausted
`ShowSuccess` SHALL set `MediaScreen.Visibility = Collapsed` and `SuccessScreen.Visibility = Visible` and populate `TxtSummary` with the session counts.

#### Scenario: Queue exhausted triggers summary
- **WHEN** `ShowNextMedia` increments index past the last file
- **THEN** `ShowSuccess` is called, `SuccessScreen` becomes visible, and `MediaScreen` is collapsed

### Requirement: Summary text shows kept, skipped, trashed, and non-media counts
`TxtSummary.Text` SHALL be formatted as:
`"Kept: {keptCount} | Skipped: {skippedCount} | Trashed: {trashedCount}\nFiltered (Non-media): {unsupportedCount}"`

#### Scenario: Counts are accurate
- **WHEN** the session ends with 5 kept, 3 skipped, 2 trashed, 1 non-media
- **THEN** `TxtSummary` shows "Kept: 5 | Skipped: 3 | Trashed: 2\nFiltered (Non-media): 1"

### Requirement: Open Destination button opens the destination folder in Explorer
`OpenDest_Click` SHALL call `Process.Start("explorer.exe", _destPath)`.

#### Scenario: Open destination
- **WHEN** user clicks "Open Destination"
- **THEN** Windows Explorer opens to the configured destination folder

### Requirement: Back to Menu resets to the setup screen
`BackToMenu_Click` SHALL set `SuccessScreen.Visibility = Collapsed` and `MenuScreen.Visibility = Visible`.

#### Scenario: Return to menu
- **WHEN** user clicks "Back to Menu"
- **THEN** `MenuScreen` is shown and `SuccessScreen` is hidden
- **THEN** the source/destination paths remain as configured

### Requirement: Complete Now allows early session termination from MediaScreen
A "Complete Now" button in `MediaScreen` SHALL stop video playback and call `ShowSuccess` immediately, bypassing remaining files in the queue.

#### Scenario: Complete Now mid-session
- **WHEN** user clicks "Complete Now" while on file 4 of 10
- **THEN** `ShowSuccess` is called with the counts accumulated so far
- **THEN** remaining files are not processed
