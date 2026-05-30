# macOS Tasks: session-summary

## 1. SuccessScreen View

- [x] 1.1 Create `macOS/MemoriesWizard/SuccessScreen.swift` with `VStack` layout in `ContentView.swift` screen container (initially hidden via `opacity(activeScreen == .success ? 1 : 0)`)
- [x] 1.2 Add `TxtSummary` `Text` displaying formatted counts: kept, skipped, trashed, unsupported in `SuccessScreen.swift`
- [x] 1.3 Add "View Collection" `Button` wired to `openDestFolder` in `SuccessScreen.swift`
- [x] 1.4 Add "Restart" `Button` wired to `backToMenu` in `SuccessScreen.swift`

## 2. Complete Now Button

- [x] 2.1 Add "Complete Now" `Button` inside `MediaScreen` controls area, wired to `completeNowTapped` in `MediaScreen.swift`

## 3. ShowSuccess Logic

- [x] 3.1 Implement `showSuccess` in `MediaScreen.swift`: set `activeScreen = .success`, populate `summaryText` with formatted counts from `keptFiles.count`, `skippedFiles.count`, `trashedFiles.count`, `unsupportedFiles.count`
- [x] 3.2 Implement `completeNowTapped` in `MediaScreen.swift`: stop AVPlayer, nil player item and image source, call `showSuccess`

## 4. Navigation

- [x] 4.1 Implement `backToMenu` in `SuccessScreen.swift`: set `activeScreen = .menu`
- [x] 4.2 Implement `openDestFolder` in `SuccessScreen.swift`: call `NSWorkspace.shared.open(destURL)`
