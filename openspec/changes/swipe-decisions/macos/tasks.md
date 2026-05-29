# macOS Tasks: swipe-decisions

## 1. Gesture Setup

- [ ] 1.1 Add `TxtIndicator` `Text` overlay inside `MediaContainer` with `.opacity(indicatorOpacity)` in `MediaScreen.swift`
- [ ] 1.2 Attach `DragGesture()` to `MediaContainer` with `.onChanged` and `.onEnded` handlers
- [ ] 1.3 Add `@State` properties: `dragOffset: CGSize`, `dragRotation: Double`, `indicatorText: String`, `indicatorColor: Color`, `isProcessing: Bool`

## 2. Drag Gesture

- [ ] 2.1 Implement `.onChanged`: update `dragOffset` from `value.translation`, set `dragRotation = value.translation.width / 15`, update indicator (text/color/opacity) based on translation direction and magnitude
- [ ] 2.2 Implement indicator logic: "KEEP" (green) when `translation.width > 50`, "SKIP" (gray) when `translation.width < -50`, "TRASH" (salmon) when `translation.height > 50 && abs(translation.height) > abs(translation.width)`, hidden otherwise
- [ ] 2.3 Implement `.onEnded`: evaluate `predictedEndTranslation` against 150pt threshold, call fly-off animation or spring-back

## 3. Animation

- [ ] 3.1 Implement fly-off animation using `withAnimation(.easeOut(duration: 0.3))`: animate `dragOffset` to `targetX, targetY`, `dragRotation` to `dragRotation * 2`, indicator to full opacity; call `processDecision` via `DispatchQueue.main.asyncAfter(deadline: .now() + 0.3)`
- [ ] 3.2 Implement spring-back using `withAnimation(.spring(response: 0.3, dampingFraction: 0.6))`: animate `dragOffset` to `.zero`, `dragRotation` to `0`, indicator opacity to `0`
- [ ] 3.3 Set `isProcessing = true` during animation and `.allowsHitTesting(!isProcessing)` on card to prevent double-fire

## 4. Keyboard Shortcuts

- [ ] 4.1 Add `.onKeyPress(.rightArrow)`, `.onKeyPress(.leftArrow)`, `.onKeyPress(.downArrow)` modifiers on `MediaScreen`, mapping to Keep/Skip/Trash fly-off animations
- [ ] 4.2 Guard keyboard handlers with `activeScreen == .media && !isProcessing`
