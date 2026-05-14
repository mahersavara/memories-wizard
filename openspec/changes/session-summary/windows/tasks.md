# Windows Tasks: session-summary

## 1. SuccessScreen XAML

- [x] 1.1 Add `SuccessScreen` Border (initially `Collapsed`) to the screen container in `win/MainWindow.xaml`
- [x] 1.2 Add `TxtSummary` TextBlock inside `SuccessScreen` in `win/MainWindow.xaml`
- [x] 1.3 Add "Open Destination" button wired to `OpenDest_Click` in `win/MainWindow.xaml`
- [x] 1.4 Add "Back to Menu" button wired to `BackToMenu_Click` in `win/MainWindow.xaml`

## 2. Complete Now Button

- [x] 2.1 Add "Complete Now" button inside `MediaScreen` wired to `CompleteNow_Click` in `win/MainWindow.xaml`

## 3. ShowSuccess Logic

- [x] 3.1 Implement `ShowSuccess` in `win/MainWindow.xaml.cs`: collapse `MediaScreen`, show `SuccessScreen`, set `TxtSummary` with formatted counts
- [x] 3.2 Implement `CompleteNow_Click` in `win/MainWindow.xaml.cs`: stop video, null source, call `ShowSuccess`

## 4. Navigation

- [x] 4.1 Implement `BackToMenu_Click` in `win/MainWindow.xaml.cs`: collapse `SuccessScreen`, show `MenuScreen`
- [x] 4.2 Implement `OpenDest_Click` in `win/MainWindow.xaml.cs`: call `Process.Start("explorer.exe", _destPath)`
