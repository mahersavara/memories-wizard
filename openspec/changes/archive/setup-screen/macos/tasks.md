# macOS Tasks: setup-screen

## 1. MenuScreen View

- [x] 1.1 Create `macOS/MemoriesWizard/MenuScreen.swift` with `VStack` layout containing source folder section and destination folder section
- [x] 1.2 Add `TxtSourcePath` `TextField` (read-only display), `Select Source` `Button`, `ChkRecursive` `Toggle`, and `TxtMediaCount` `Text` for source folder section
- [x] 1.3 Add `TxtDestPath` `TextField` (read-only display) and `Select Destination` `Button` for destination folder section
- [x] 1.4 Add "Begin Sorting" `Button` at bottom of `VStack`

## 2. Source Folder Logic

- [x] 2.1 Implement `browseSource` using `NSOpenPanel` (wrapped via `NSViewRepresentable` or direct `NSOpenPanel.runModal`) to select directory; store result in `@State sourcePath`
- [x] 2.2 Implement `updateMediaCount()` calling `mediaService.scanMedia(sourcePath, recursive)` and updating `@State mediaCount` on main actor
- [x] 2.3 Implement `.onChange(of: sourcePath)` triggering `updateMediaCount()`
- [x] 2.4 Implement `.onChange(of: recursive)` triggering `updateMediaCount()`; persist `recursive` via `@AppStorage("recursiveScan")`

## 3. Destination Folder Logic

- [x] 3.1 Implement `browseDest` using `NSOpenPanel` to select directory; store result in `@State destPath`

## 4. Start Validation

- [x] 4.1 Implement `startSorting` with guard checking `!sourcePath.isEmpty && !destPath.isEmpty`
- [x] 4.2 Show `.alert("Please select both folders.")` when validation fails
- [x] 4.3 On successful validation, call `initializeMediaQueue()` and set `activeScreen = .media`
