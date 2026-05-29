# Windows Design: swipe-decisions

## Context
All gesture handling is in `MainWindow` (no MVVM). `MediaTransform` (`TranslateTransform`) and `MediaRotate` (`RotateTransform`) are part of a `TransformGroup` on `MediaContainer`. `TxtIndicator` is overlaid inside `MediaContainer`.

## Goals / Non-Goals
**Goals**: Fluid, responsive gesture UX with clear visual feedback.  
**Non-Goals**: Touch input, multi-touch, no file operations.

## Decisions

### `BackEase` for spring-back animation
`BackEase(Amplitude=0.5, EaseOut)` produces a slight overshoot-and-settle that matches natural "snapping back" feel without custom physics.

### `AnimateOffScreen` fires `ProcessDecision` via `Completed` event
Keeps decision processing decoupled from animation — the card flies off completely before file operations begin, preventing UI jank.

### `SwipeThreshold = 150px` constant
A constant (not magic number) makes it easy to tune. 150px is ~15% of a 1000px wide window, matching common swipe-app conventions.

## Mermaid: Swipe Interaction Flow

```mermaid
flowchart TD
    A[MouseLeftButtonDown] --> B[Capture mouse, record _startPoint]
    B --> C[MouseMove events]
    C --> D[Translate + Tilt card]
    D --> E[Show directional indicator]
    E --> F[MouseLeftButtonUp]
    F --> G{|deltaX| or |deltaY| >= 150?}
    G -->|No| H[Spring back - BackEase 250ms]
    G -->|Yes, right| I[AnimateOffScreen Keep → fly right]
    G -->|Yes, left| J[AnimateOffScreen Skip → fly left]
    G -->|Yes, down| K[AnimateOffScreen Trash → fly down]
    I --> L[ProcessDecision on Completed]
    J --> L
    K --> L
```

## Risks / Trade-offs
- [Risk] Rapid keyboard presses before animation completes can double-fire `ProcessDecision` → Mitigation: `_isDragging` guard; additional input lock can be added in a future change.

## Migration Plan
N/A — new capability.

## Open Questions
*(none)*
