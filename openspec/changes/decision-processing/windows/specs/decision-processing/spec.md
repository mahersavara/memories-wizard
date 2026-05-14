# Windows Spec: decision-processing

## ADDED Requirements

### Requirement: Keep decision moves file to destination folder
`MoveToDestination` SHALL move the source file to `_destPath`. If the destination directory does not exist, it SHALL be created. If a file with the same name already exists at the destination, the moved file SHALL be prefixed with a `Guid.NewGuid()` string.

#### Scenario: Keep with unique filename
- **WHEN** `ProcessDecision(Decision.Keep)` is called and no filename collision exists
- **THEN** the file is moved to `_destPath` with its original name

#### Scenario: Keep with filename collision
- **WHEN** a file with the same name already exists in `_destPath`
- **THEN** the file is moved with a GUID prefix (e.g., `abc123_photo.jpg`)

#### Scenario: Keep creates destination if missing
- **WHEN** `_destPath` directory does not exist
- **THEN** the directory is created and the file is moved successfully

### Requirement: Trash decision sends file to OS recycle bin
`SendToRecycleBin` SHALL use `Microsoft.VisualBasic.FileIO.FileSystem.DeleteFile` with `RecycleOption.SendToRecycleBin`. If that fails, it SHALL fall back to moving the file to a `.trash` subfolder in the source directory.

#### Scenario: Trash via recycle bin
- **WHEN** `ProcessDecision(Decision.Trash)` is called
- **THEN** the file is moved to the OS recycle bin

#### Scenario: Trash fallback to .trash folder
- **WHEN** the recycle bin operation throws an exception
- **THEN** the file is moved to a `.trash/` subdirectory next to the source file

### Requirement: Skip decision records the file without any file operation
`ProcessDecision(Decision.Skip)` SHALL add the file path to `_skippedFiles` and advance the queue without moving or deleting the file.

#### Scenario: Skip does not modify the file
- **WHEN** `ProcessDecision(Decision.Skip)` is called
- **THEN** the file remains at its original path
- **THEN** `_skippedFiles` count increases by one

### Requirement: File operations retry on IOException up to 5 times
`ExecuteWithRetry` SHALL catch `IOException`, sleep 200ms, and retry up to 5 times. On the 5th failure it SHALL rethrow.

#### Scenario: Retry succeeds on second attempt
- **WHEN** the first file operation throws `IOException` and the second attempt succeeds
- **THEN** the operation completes without surfacing an error

#### Scenario: All retries exhausted
- **WHEN** all 5 attempts throw `IOException`
- **THEN** the exception propagates to the caller

### Requirement: ProcessDecision surfaces errors via MessageBox
If any file operation throws an exception, `ProcessDecision` SHALL catch it and show a `MessageBox` with the error message, then advance the queue.

#### Scenario: Error on Keep
- **WHEN** `MoveToDestination` throws an exception
- **THEN** a MessageBox shows the error message
- **THEN** the queue advances to the next file

### Requirement: Session tracking lists record all outcomes
`_keptFiles`, `_skippedFiles`, `_trashedFiles` SHALL accumulate file paths for their respective decisions throughout the session. `_unsupportedFiles` tracks non-media files from the scan.

#### Scenario: End of session counts reflect decisions
- **WHEN** the user keeps 3, skips 2, trashes 1 out of 6 files
- **THEN** `_keptFiles.Count == 3`, `_skippedFiles.Count == 2`, `_trashedFiles.Count == 1`
