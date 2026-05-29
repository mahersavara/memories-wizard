# macOS Tasks: project-setup

## 1. Project File

- [ ] 1.1 Create `macOS/MemoriesWizard/` directory with `Package.swift` targeting macOS 14+, using `SwiftToolsVersion 5.9`
- [ ] 1.2 Add `Info.plist` with `CFBundleIconFile`, `CFBundleName`, `CFBundleIdentifier`, `LSMinimumSystemVersion "14.0"`

## 2. Application Entry Point

- [ ] 2.1 Create `macOS/MemoriesWizard/App.swift` with `@main` struct conforming to `App`, using `WindowGroup`
- [ ] 2.2 Create `macOS/MemoriesWizard/Theme.swift` defining shared colors, fonts, corner radii, and button style primitives
- [ ] 2.3 Register crash handlers in `App.init()`: `NSSetUncaughtExceptionHandler` for Obj-C exceptions and signal handler (`SIGILL`, `SIGTRAP`, `SIGABRT`) for Swift runtime; write exception message + stack trace to `crash.log` in app support directory; show `NSAlert` with error details and log path
- [ ] 2.4 Create `macOS/MemoriesWizard/ContentView.swift` as the root view, loading Theme via `.environmentObject`

## 3. Resources

- [ ] 3.1 Create `macOS/MemoriesWizard/Resources/` directory
- [ ] 3.2 Add `AppIcon` image set to `Assets.xcassets` with icon variants (16x16 through 1024x1024)
- [ ] 3.3 Add `icon.png` to Resources for the in-window title bar icon

## 4. Validation

- [ ] 4.1 Run `swift build` in `macOS/MemoriesWizard/` and confirm zero errors
- [ ] 4.2 Launch app and verify window icon and theme styles are applied
- [ ] 4.3 Verify crash handler fires and writes `crash.log` when an unhandled exception occurs
