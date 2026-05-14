# Windows Tasks: app-shell

## 1. Window Configuration

- [x] 1.1 Set `WindowStyle="None"`, `AllowsTransparency="True"`, `WindowStartupLocation="CenterScreen"`, `Width="500"`, `Height="700"` on `Window` in `win/MainWindow.xaml`
- [x] 1.2 Add `WindowChrome` with `CaptionHeight="50"` and `ResizeBorderThickness="5"` in `win/MainWindow.xaml`

## 2. Rounded Window Shell

- [x] 2.1 Wrap window content in an outer `Border` with `CornerRadius="12"` and `ClipToBounds="True"` in `win/MainWindow.xaml`

## 3. Screen Panels

- [x] 3.1 Add a `Grid` inside the outer Border to host screen panels in `win/MainWindow.xaml`
- [x] 3.2 Add `MenuScreen` Border (`Visibility=Visible`) as the first screen panel in `win/MainWindow.xaml`
- [x] 3.3 Add `MediaScreen` Border (`Visibility=Collapsed`) as the second screen panel in `win/MainWindow.xaml`
- [x] 3.4 Add `SuccessScreen` Border (`Visibility=Collapsed`) as the third screen panel in `win/MainWindow.xaml`

## 4. Constructor Wiring

- [x] 4.1 Declare `_mediaService: IMediaService` field in `win/MainWindow.xaml.cs`
- [x] 4.2 Instantiate `new MediaService()` and assign to `_mediaService` in the constructor in `win/MainWindow.xaml.cs`
- [x] 4.3 Attach `MainWindow_KeyDown` handler to `KeyDown` event in the constructor in `win/MainWindow.xaml.cs`
