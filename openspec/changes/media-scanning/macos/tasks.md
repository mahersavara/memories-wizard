# macOS Tasks: media-scanning

## 1. Service Definition

- [ ] 1.1 Create `macOS/MemoriesWizard/MediaService.swift` with `MediaServiceProtocol` declaring `scanMedia(sourceURL:recursive:) -> MediaScanResult`
- [ ] 1.2 Add `MediaScanResult` struct with `var mediaFiles: [URL]` and `var unsupportedFiles: [URL]` properties, both defaulting to `[]`
- [ ] 1.3 Add `Decision` enum (`keep`, `skip`, `trash`) to `MediaService.swift`

## 2. MediaService Implementation

- [ ] 2.1 Implement `scanMedia` with URL validity guard; return empty `MediaScanResult` on `nil` or non-existent URL
- [ ] 2.2 Add `mediaExtensions` static `Set<String>`: `"jpg"`, `"jpeg"`, `"png"`, `"gif"`, `"bmp"`, `"mp4"`, `"mov"`, `"wmv"`, `"avi"`
- [ ] 2.3 Implement `FileManager.default.enumerator(at:includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey])` for lazy file enumeration
- [ ] 2.4 Implement dot-prefix hidden file exclusion checking `url.lastPathComponent.hasPrefix(".")` in the enumeration loop
- [ ] 2.5 Partition files into `mediaFiles` vs `unsupportedFiles` based on `mediaExtensions.contains(url.pathExtension.lowercased())`

## 3. Integration

- [ ] 3.1 Create `MediaService` as `@StateObject` in `ContentView.swift` and pass via `.environmentObject(mediaService)`
