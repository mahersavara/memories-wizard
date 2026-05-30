# Spec: session-summary

## ADDED Requirements

### Requirement: Summary view is shown when queue is exhausted
When the queue is exhausted, the app SHALL display the summary view and populate it with session counts.

#### Scenario: Queue exhausted triggers summary
- **WHEN** the user advances beyond the last media item
- **THEN** summary view is shown and review view is hidden

### Requirement: Summary text shows kept, skipped, trashed, and non-media counts
Summary text SHALL display kept, skipped, trashed, and filtered non-media counts in a readable format.

#### Scenario: Counts are accurate
- **WHEN** the session ends with 5 kept, 3 skipped, 2 trashed, 1 non-media
- **THEN** summary content reflects those exact counts

### Requirement: View Collection button opens the destination folder in system file manager
The view collection action SHALL open the configured destination folder in the system file manager.

#### Scenario: Open destination
- **WHEN** user clicks "View Collection"
- **THEN** the system file manager opens to the configured destination folder

### Requirement: Restart button resets to the setup screen
The restart action SHALL return the user from summary view to setup view.

#### Scenario: Return to menu
- **WHEN** user clicks "Restart"
- **THEN** setup view is shown and summary view is hidden
- **THEN** the source/destination paths remain as configured

### Requirement: Complete Now allows early session termination from review view
A complete-now action in review view SHALL end the session immediately and show summary without processing remaining items.

#### Scenario: Complete Now mid-session
- **WHEN** user clicks "Complete Now" while on file 4 of 10
- **THEN** summary is shown with counts accumulated so far
- **THEN** remaining files are not processed

#### Scenario: Complete Now releases active media resources
- **WHEN** user clicks "Complete Now" during active media playback
- **THEN** active media playback resources are released before summary view is shown
