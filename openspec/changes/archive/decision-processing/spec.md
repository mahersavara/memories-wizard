# Spec: decision-processing

## ADDED Requirements

### Requirement: Keep decision moves file to destination folder
When a Keep decision is made, the app SHALL move the current file to the configured destination folder. If the destination does not exist, it SHALL be created. If a name collision exists, a unique prefix SHALL be applied.

#### Scenario: Keep with unique filename
- **WHEN** Keep is selected and no filename collision exists
- **THEN** the file is moved to destination with its original name

#### Scenario: Keep with filename collision
- **WHEN** a file with the same name already exists in destination
- **THEN** the file is moved with a GUID prefix (e.g., `abc123_photo.jpg`)

#### Scenario: Keep creates destination if missing
- **WHEN** destination directory does not exist
- **THEN** the directory is created and the file is moved successfully

### Requirement: Trash decision sends file to platform trash
When a Trash decision is made, the app SHALL send the file to the operating system trash mechanism. If that fails, the app SHALL move the file to a hidden trash subfolder under source.

#### Scenario: Trash via recycle bin
- **WHEN** Trash is selected
- **THEN** the file is moved to the OS recycle bin

#### Scenario: Native trash operation may delegate error prompts to host UI
- **WHEN** a recoverable native trash error occurs
- **THEN** the host system MAY present native error prompts
- **THEN** app flow remains consistent with decision handling rules

#### Scenario: Trash fallback to .trash folder
- **WHEN** the recycle bin operation throws an exception
- **THEN** the file is moved to a `.trash/` subdirectory next to the source file

### Requirement: Skip decision records the file without any file operation
When a Skip decision is made, the app SHALL record the file as skipped and advance the queue without moving or deleting the file.

#### Scenario: Skip does not modify the file
- **WHEN** Skip is selected
- **THEN** the file remains at its original path
- **THEN** skipped count increases by one

### Requirement: File operations retry on transient I O failures up to five times
File operations SHALL retry transient I O errors with short delay, up to five attempts, and then fail if all attempts are exhausted.

#### Scenario: Retry succeeds on second attempt
- **WHEN** the first file operation fails with transient I O error and the second succeeds
- **THEN** the operation completes without surfacing an error

#### Scenario: All retries exhausted
- **WHEN** all five attempts fail with transient I O errors
- **THEN** the exception propagates to the caller

#### Scenario: Retry cadence is short and consistent
- **WHEN** transient I O failures trigger retries
- **THEN** retries are spaced by a short, fixed delay

### Requirement: Decision handling surfaces errors via user notification
If file operation errors occur, the app SHALL show an error notification and continue queue progression.

#### Scenario: Error on Keep
- **WHEN** destination move fails
- **THEN** an error notification shows the error message
- **THEN** the queue advances to the next file

### Requirement: Session tracking lists record all outcomes
Session tracking SHALL accumulate counts and item references for kept, skipped, trashed, and unsupported files.

#### Scenario: End of session counts reflect decisions
- **WHEN** the user keeps 3, skips 2, trashes 1 out of 6 files
- **THEN** kept count is 3, skipped count is 2, and trashed count is 1

### Requirement: Media sources are released before file operations
Before any move or trash operation, active media resources SHALL be released to avoid file locks.

#### Scenario: Video file can be moved immediately after decision
- **WHEN** a decision is made while video playback is active
- **THEN** playback resources are released before file operation starts
- **THEN** move can proceed without lock-related I O failure

### Requirement: Session tracking lists are cleared at the start of each new session
At the start of each new session, kept, skipped, and trashed tracking SHALL reset to empty state.

#### Scenario: Repeated session starts with fresh counts
- **WHEN** the user completes a session and clicks "Restart" to begin a new session
- **THEN** kept, skipped, and trashed tracking are empty at session start
