# Spec: swipe-decisions

## ADDED Requirements

### Requirement: Dragging the card translates and tilts it
During pointer drag on the media card, the card SHALL translate with pointer movement and rotate proportionally to horizontal displacement.

#### Scenario: Drag right tilts card clockwise
- **WHEN** user drags the card 60px to the right
- **THEN** the card is positioned 60px right and rotated 4° clockwise

### Requirement: Direction indicator overlay shows intent
The decision indicator SHALL appear with opacity proportional to drag distance and show:
- "KEEP" (LightGreen) when `deltaX > 50`
- "SKIP" (LightGray) when `deltaX < -50`
- "TRASH" (Salmon) when `deltaY > 50` and `|deltaY| > |deltaX|`
- Hidden (opacity 0) otherwise

#### Scenario: Right drag shows KEEP label
- **WHEN** user drags 75px right (50% of threshold)
- **THEN** "KEEP" text is visible at ~50% opacity in green

### Requirement: Releasing below threshold springs card back to centre
When released below decision thresholds, the card SHALL animate back to neutral position and angle, and the indicator SHALL fade out.

#### Scenario: Small drag springs back
- **WHEN** user drags 80px right and releases
- **THEN** card animates back to centre with a spring bounce

### Requirement: Releasing above threshold animates card off-screen and fires decision
When released above a decision threshold, the card SHALL animate off-screen and then commit the mapped decision outcome.

#### Scenario: Swipe right commits Keep
- **WHEN** user releases after dragging more than 150px right
- **THEN** card flies off to the right and Keep is committed after animation

#### Scenario: Swipe down commits Trash
- **WHEN** user releases after dragging more than 150px down
- **THEN** card flies off downward and Trash is committed after animation

### Requirement: In-progress card animations are cancelled when a new drag begins
If a new drag begins while card animation is in progress, active animations SHALL be canceled before applying new pointer movement.

#### Scenario: New drag interrupts spring-back
- **WHEN** the user begins dragging the card while a spring-back animation is in progress
- **THEN** the spring-back is cancelled immediately and the card responds to the new drag position

### Requirement: Keyboard shortcuts trigger decisions
While media review is active, keyboard shortcuts SHALL immediately trigger the same decision flow as swipes:
- Right arrow commits Keep
- Left arrow commits Skip
- Down arrow commits Trash

#### Scenario: Right arrow key commits Keep
- **WHEN** media review is visible and user presses right arrow
- **THEN** card animates off-screen right and Keep is committed

### Requirement: Mouse capture prevents missed events
The drag interaction SHALL capture pointer input at drag start and release capture at drag end.

#### Scenario: Drag continues past container boundary
- **WHEN** user drags outside the card bounds
- **THEN** drag continues to track because mouse is captured
