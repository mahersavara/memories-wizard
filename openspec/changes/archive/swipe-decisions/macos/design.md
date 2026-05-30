# macOS Design: swipe-decisions

## Context
SwiftUI's native `DragGesture` provides built-in translation tracking, velocity, and predicted end location -- no manual mouse event handling needed. The gesture is attached to the media card via `.gesture(DragGesture().onChanged { ... }.onEnded { ... })`.

SwiftUI animations are declarative: `.animation(.spring())` for spring-back, `withAnimation(.easeOut) { }` for fly-off. There is no `Storyboard`/`DoubleAnimation` equivalent; the animation system handles interpolation natively.

## Goals / Non-Goals
**Goals**: Fluid, responsive gesture UX with real-time visual feedback and keyboard shortcuts.  
**Non-Goals**: Touch/Multi-touch, no file operations (those are in decision-processing).

## Decisions

### SwiftUI `DragGesture` over AppKit `NSEvent` monitoring
`DragGesture` is the idiomatic SwiftUI way to handle drag interactions. It provides `.onChanged` (real-time translation), `.onEnded` (release with velocity and predicted end), and automatically handles gesture conflicts with scroll views. No manual `NSEvent.addLocalMonitor` needed.

### `.offset(x:y:)` + `.rotationEffect(.degrees())` for card transform
SwiftUI applies `.offset` and `.rotationEffect` as combined affine transforms on the GPU. No `TransformGroup` / `RenderTransform` needed -- these modifiers compose naturally. `rotationEffect` is proportional to `translation.width / 15` matching the spec's tilt behavior.

### `withAnimation(.spring(response: 0.3, dampingFraction: 0.6))` for spring-back
SwiftUI's spring animation with custom damping produces natural overshoot-and-settle matching the `BackEase` feel. More tunable than WPF's `BackEase` and doesn't require manual keyframe definitions.

### `.onKeyPress` for keyboard shortcuts
SwiftUI's `.onKeyPress(.leftArrow)`, `.onKeyPress(.rightArrow)`, `.onKeyPress(.downArrow)` modifiers handle keyboard input declaratively, without needing a global key event handler. They respect SwiftUI's focus system automatically.

### SwipeThreshold = 150pt (not px)
macOS uses points (1pt = 1px on non-Retina, 2px on Retina). 150pt is ~15% of a 1000pt wide window, matching the same proportion as the Windows implementation.

## Mermaid: Swipe Interaction Flow

```mermaid
flowchart TD
    A[DragGesture.onChanged] --> B[Update offset + rotation]
    B --> C[Update indicator text/color/opacity]
    C --> D[DragGesture.onEnded]
    D --> E{|translation| >= 150?}
    E -->|No| F[Spring-back animation]
    E -->|Yes, right| G[Fly-off right -> Keep]
    E -->|Yes, left| H[Fly-off left -> Skip]
    E -->|Yes, down| I[Fly-off down -> Trash]
    G --> J[processDecision on animation completion]
    H --> J
    I --> J
```

## Risks / Trade-offs
- [Risk] Rapid keyboard presses before animation completes can double-fire `processDecision` → Mitigation: `isProcessing` `@State` guard blocks new input during animation. Disabled gesture during animation via `.allowsHitTesting(!isProcessing)`.
- [Risk] `DragGesture` minimum distance may feel laggy on trackpad → Mitigation: default minimum distance is 0 for explicit gestures; ensure no competing gestures (ScrollView, etc.) in the card area.

## Migration Plan
N/A -- new capability.

## Open Questions
*(none)*
