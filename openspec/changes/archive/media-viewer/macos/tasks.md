# macOS Tasks: media-viewer

## 1. MediaScreen View

- [x] 1.1 Create `macOS/MemoriesWizard/MediaScreen.swift` with `ZStack` containing `MediaContainer` (the card area) and controls overlay
- [x] 1.2 Add `ImgPreview` `Image` view inside `MediaContainer` with `.resizable().aspectRatio(contentMode: .fit)`
- [x] 1.3 Add `TxtFileName` `Text`, `TxtCurrentIndex` `TextField` (editable, with `.onSubmit`), and `TxtTotalCount` `Text` in controls area
- [x] 1.4 Add `.offset(x:)` and `.rotationEffect(.degrees())` modifiers on `MediaContainer` driven by `@State` variables

## 2. Queue Initialisation

- [x] 2.1 Implement `initializeMediaQueue` in `MediaScreen.swift`: call `mediaService.scanMedia`, check `mediaFiles.isEmpty`, show alert if empty, set `currentIndex = 0`, transition `activeScreen` to `.media`
- [x] 2.2 Implement `advanceToNext` incrementing `currentIndex` and calling `showSuccess` when `currentIndex >= mediaFiles.count`

## 3. Image Loading

- [x] 3.1 Implement image branch in `loadCurrentMedia`: create `NSImage(contentsOf:)`, generate thumbnail at max 1200px using `NSImageRep`, assign to `@State image`
- [x] 3.2 Reset `offset`, `rotation`, and `indicatorOpacity` at start of `loadCurrentMedia` with `.animation(.none, value: currentIndex)`

## 4. Jump to Index

- [x] 4.1 Implement `TxtCurrentIndex` `.onSubmit`: parse `Int` from input, validate `1...mediaFiles.count`, navigate to valid index or restore previous value
- [x] 4.2 After valid jump, move `@FocusState` back to media interaction area for keyboard shortcuts
