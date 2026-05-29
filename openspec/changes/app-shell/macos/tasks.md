# macOS Tasks: app-shell

## 1. Window Configuration

- [ ] 1.1 In `App.swift`, add `NSApplicationDelegate` adapter to configure window: set `titlebarAppearsTransparent = true`, `titleVisibility = .hidden`, `styleMask.insert(.fullSizeContentView)` in `applicationDidFinishLaunching`
- [ ] 1.2 Set default window size 1000x700 and center on screen

## 2. Rounded Window Shell

- [ ] 2.1 In `ContentView.swift`, add outer `ZStack` with `.clipShape(RoundedRectangle(cornerRadius: 30))` for rounded corners
- [ ] 2.2 Apply gradient background via `.background(LinearGradient(...))` inside the rounded container

## 3. Custom Title Bar

- [ ] 3.1 Add title bar `HStack` (height 50) with window icon, app title, and spacer in `ContentView.swift`
- [ ] 3.2 Make title bar draggable via `NSWindow.performDrag(with:)` triggered by a transparent drag zone
- [ ] 3.3 Add Minimize, Maximize/Restore, and Close buttons using `NSApp.keyWindow?.miniaturize()`, `.toggleFullScreen()`, `.close()` respectively

## 4. Screen Panels

- [ ] 4.1 Add `@State private var activeScreen: Screen = .menu` enum (`menu`, `media`, `success`) in `ContentView.swift`
- [ ] 4.2 Add `MenuScreen` view with `.opacity(activeScreen == .menu ? 1 : 0)` and `.disabled(activeScreen != .menu)` in `ContentView.swift`
- [ ] 4.3 Add `MediaScreen` view with `.opacity(activeScreen == .media ? 1 : 0)` and `.disabled(activeScreen != .media)` in `ContentView.swift`
- [ ] 4.4 Add `SuccessScreen` view with `.opacity(activeScreen == .success ? 1 : 0)` and `.disabled(activeScreen != .success)` in `ContentView.swift`

## 5. Constructor Wiring

- [ ] 5.1 Create `MediaService` as `@StateObject` in `ContentView.swift` and inject via `.environmentObject()`
- [ ] 5.2 Add `.onKeyPress` handlers for global keyboard shortcuts (right arrow, left arrow, down arrow) guarded by `activeScreen == .media`
