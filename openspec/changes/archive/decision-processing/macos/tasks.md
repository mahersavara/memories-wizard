# macOS Tasks: decision-processing

## 1. MediaService File Operations

- [x] 1.1 Implement `moveToDestination(source: URL, destDir: URL)` in `MediaService.swift`: check source exists, create dest dir via `FileManager.createDirectory`, handle collision with UUID prefix, call `executeWithRetry`
- [x] 1.2 Implement `sendToTrash(file: URL)` in `MediaService.swift`: guard file exists, attempt `FileManager.trashItem(at:resultingItemURL:)`, catch and fall back to `.trash` subfolder move
- [x] 1.3 Implement `executeWithRetry(block:)` in `MediaService.swift`: loop up to 5 times catching `NSError`, `Thread.sleep(forTimeInterval: 0.2)` between attempts, rethrow on exhaustion

## 2. ProcessDecision in MediaScreen

- [x] 2.1 Implement `processDecision(_ decision: Decision)` in `MediaScreen.swift`: stop AVPlayer, nil image source, switch on decision type, catch errors with `.alert`
- [x] 2.2 Wire `processDecision` as the callback from swipe animation completion in `MediaScreen.swift`

## 3. Session Tracking

- [x] 3.1 Declare `@State var keptFiles: [URL]`, `skippedFiles: [URL]`, `trashedFiles: [URL]`, `unsupportedFiles: [URL]` in `MediaScreen.swift`
- [x] 3.2 Clear all session lists at the start of `initializeMediaQueue` in `MediaScreen.swift`
