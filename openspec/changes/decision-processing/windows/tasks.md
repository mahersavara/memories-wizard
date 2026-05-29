# Windows Tasks: decision-processing

## 1. MediaService File Operations

- [x] 1.1 Implement `MoveToDestination` in `win/MediaService.cs`: check source exists, create dest dir, handle collision with GUID prefix, call `ExecuteWithRetry`
- [x] 1.2 Implement `SendToRecycleBin` in `win/MediaService.cs`: guard file exists, attempt `FileSystem.DeleteFile`, catch and fall back to `.trash` folder
- [x] 1.3 Implement `ExecuteWithRetry` in `win/MediaService.cs`: loop up to 5 times catching `IOException`, `Thread.Sleep(200)` between attempts, rethrow on exhaustion

## 2. ProcessDecision in MainWindow

- [x] 2.1 Implement `ProcessDecision(Decision)` in `win/MainWindow.xaml.cs`: stop video, clear image source, switch on decision type, catch exceptions with MessageBox
- [x] 2.2 Wire `ProcessDecision` as the `Completed` callback in `AnimateOffScreen` in `win/MainWindow.xaml.cs`

## 3. Session Tracking

- [x] 3.1 Declare `_keptFiles`, `_skippedFiles`, `_trashedFiles`, `_unsupportedFiles` as `List<string>` fields in `win/MainWindow.xaml.cs`
- [x] 3.2 Clear all session lists at the start of `InitializeMediaQueue` in `win/MainWindow.xaml.cs`
