# Windows Tasks: app-shell

## 1. Window Configuration

- [x] 1.1 Set `WindowStyle="None"`, `AllowsTransparency="True"`, `WindowStartupLocation="CenterScreen"`, `Width="1000"`, `Height="700"` on `Window` in `win/MainWindow.xaml`
- [x] 1.2 Add `WindowChrome` with `CaptionHeight="50"` and `ResizeBorderThickness="8"` in `win/MainWindow.xaml`

## 2. Rounded Window Shell

- [x] 2.1 Add outer background `Border` with `CornerRadius="30"` for the gradient background in `win/MainWindow.xaml` (corner clipping is provided by `WindowChrome.CornerRadius="30"`, not `ClipToBounds`)

## 3. Custom Title Bar

- [x] 3.1 Add title bar `Grid` row (height 50) with `MouseLeftButtonDown` wired to `TitleBar_MouseLeftButtonDown` for window drag in `win/MainWindow.xaml`
- [x] 3.2 Add Minimize (`—`), Maximize/Restore (`▢`), and Close (`✕`) buttons with `WindowChrome.IsHitTestVisibleInChrome="True"` in `win/MainWindow.xaml`
- [x] 3.3 Implement `Minimize_Click`, `Maximize_Click` (toggles `WindowState` and button content between `▢` and `❐`), and `Close_Click` in `win/MainWindow.xaml.cs`

## 4. Screen Panels

- [x] 4.1 Add a `Grid` inside the outer Border to host screen panels in `win/MainWindow.xaml`
- [x] 4.2 Add `MenuScreen` Border (`Visibility=Visible`) as the first screen panel in `win/MainWindow.xaml`
- [x] 4.3 Add `MediaScreen` Border (`Visibility=Collapsed`) as the second screen panel in `win/MainWindow.xaml`
- [x] 4.4 Add `SuccessScreen` Border (`Visibility=Collapsed`) as the third screen panel in `win/MainWindow.xaml`

## 5. Constructor Wiring

- [x] 5.1 Declare `_mediaService: IMediaService` field in `win/MainWindow.xaml.cs`
- [x] 5.2 Instantiate `new MediaService()` and assign to `_mediaService` in the constructor in `win/MainWindow.xaml.cs`
- [x] 5.3 Attach `MainWindow_KeyDown` handler to `KeyDown` event in the constructor in `win/MainWindow.xaml.cs`
