# Windows Tasks: swipe-decisions

## 1. XAML Setup

- [x] 1.1 Add `TxtIndicator` TextBlock overlay inside `MediaContainer` in `win/MainWindow.xaml`
- [x] 1.2 Bind `MouseLeftButtonDown`, `MouseMove`, `MouseLeftButtonUp` events on `MediaContainer` in `win/MainWindow.xaml`
- [x] 1.3 Set `RenderTransformOrigin="0.5,0.8"` on `MediaContainer` in `win/MainWindow.xaml`

## 2. Drag Gesture

- [x] 2.1 Implement `MediaContainer_MouseLeftButtonDown`: record `_startPoint`, set `_isDragging`, call `CaptureMouse`, clear pending animations in `win/MainWindow.xaml.cs`
- [x] 2.2 Implement `MediaContainer_MouseMove`: update `MediaTransform.X/Y` and `MediaRotate.Angle = deltaX/15`, update `TxtIndicator` text/color/opacity in `win/MainWindow.xaml.cs`
- [x] 2.3 Implement `MediaContainer_MouseLeftButtonUp`: release capture, evaluate thresholds, call `AnimateOffScreen` or spring-back in `win/MainWindow.xaml.cs`

## 3. Animation

- [x] 3.1 Implement `AnimateOffScreen(Decision, targetX, targetY)` with 250ms `DoubleAnimation` and `ProcessDecision` called on `Completed` in `win/MainWindow.xaml.cs`
- [x] 3.2 Implement spring-back using `BackEase(Amplitude=0.5, EaseOut)` for X, Y, and Angle in `win/MainWindow.xaml.cs`

## 4. Keyboard Shortcuts

- [x] 4.1 Subscribe to `KeyDown` in constructor: `this.KeyDown += MainWindow_KeyDown` in `win/MainWindow.xaml.cs`
- [x] 4.2 Implement `MainWindow_KeyDown` guarding on `MediaScreen.Visibility`, mapping →/←/↓ to `AnimateOffScreen` calls in `win/MainWindow.xaml.cs`
