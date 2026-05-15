# Windows Spec: swipe-decisions

## ADDED Requirements

### Requirement: Dragging the card translates and tilts it
During a left-button drag on `MediaContainer`, the card SHALL translate to match cursor delta (`X = deltaX`, `Y = deltaY`) and rotate proportionally (`Angle = deltaX / 15.0`).

#### Scenario: Drag right tilts card clockwise
- **WHEN** user drags the card 60px to the right
- **THEN** the card is positioned 60px right and rotated 4° clockwise

### Requirement: Direction indicator overlay shows intent
A `TxtIndicator` TextBlock SHALL appear with opacity proportional to `|delta| / SwipeThreshold (150)`, showing:
- "KEEP" (LightGreen) when `deltaX > 50`
- "SKIP" (LightGray) when `deltaX < -50`
- "TRASH" (Salmon) when `deltaY > 50` and `|deltaY| > |deltaX|`
- Hidden (opacity 0) otherwise

#### Scenario: Right drag shows KEEP label
- **WHEN** user drags 75px right (50% of threshold)
- **THEN** "KEEP" text is visible at ~50% opacity in green

### Requirement: Releasing below threshold springs card back to centre
When mouse is released with `|deltaX| < 150` and `|deltaY| < 150`, the card SHALL animate back to position (0, 0) with angle 0 using `BackEase(Amplitude=0.5, EaseOut)` over 250ms. The indicator SHALL fade to opacity 0 over 150ms.

#### Scenario: Small drag springs back
- **WHEN** user drags 80px right and releases
- **THEN** card animates back to centre with a spring bounce

### Requirement: Releasing above threshold animates card off-screen and fires decision
When mouse is released with `deltaX > 150` (Keep), `deltaX < -150` (Skip), or `deltaY > 150` (Trash), the card SHALL animate to (`±1000`, offset) or (`offset`, `1000`) over 300ms and call `ProcessDecision` on animation completion.

#### Scenario: Swipe right commits Keep
- **WHEN** user releases after dragging more than 150px right
- **THEN** card flies off to the right and `ProcessDecision(Decision.Keep)` is called after 300ms

#### Scenario: Swipe down commits Trash
- **WHEN** user releases after dragging more than 150px down
- **THEN** card flies off downward and `ProcessDecision(Decision.Trash)` is called after 300ms

### Requirement: Keyboard shortcuts trigger decisions
While `MediaScreen` is visible, the following keys SHALL trigger `AnimateOffScreen` immediately:
- → (`Key.Right`): `Decision.Keep`
- ← (`Key.Left`): `Decision.Skip`
- ↓ (`Key.Down`): `Decision.Trash`

#### Scenario: Right arrow key commits Keep
- **WHEN** `MediaScreen` is visible and user presses →
- **THEN** card animates off-screen right and `ProcessDecision(Decision.Keep)` is called

### Requirement: Mouse capture prevents missed events
On `MouseLeftButtonDown`, `MediaContainer.CaptureMouse()` SHALL be called. On `MouseLeftButtonUp`, `ReleaseMouseCapture()` SHALL be called.

#### Scenario: Drag continues past container boundary
- **WHEN** user drags outside the MediaContainer bounds
- **THEN** drag continues to track because mouse is captured
