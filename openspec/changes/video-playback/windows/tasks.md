# Windows Tasks: video-playback

## 1. XAML Controls

- [x] 1.1 Add `VidPreview` MediaElement inside `MediaContainer` (`LoadedBehavior=Manual`, `UnloadedBehavior=Stop`, `ScrubbingEnabled=True`, `Volume=0.5`) in `win/MainWindow.xaml`
- [x] 1.2 Add `VidControls` overlay Border (`VerticalAlignment=Bottom`, initially `Collapsed`) with seek, time, volume, and speed controls in `win/MainWindow.xaml`
- [x] 1.3 Add `SldSeek` Slider with `DragStarted`, `DragCompleted`, `ValueChanged` events in `win/MainWindow.xaml`
- [x] 1.4 Add `TxtVidTime` TextBlock, `SldVolume` Slider (0–1, default 0.5), `CmbSpeed` ComboBox (0.5x/0.75x/1.0x/1.25x/1.5x, default index 2) in `win/MainWindow.xaml`

## 2. Playback Logic

- [x] 2.1 Subscribe `MediaOpened`, `MediaEnded`, `MediaFailed` events on `VidPreview` in `win/MainWindow.xaml.cs` constructor
- [x] 2.2 Implement `VidPreview_MediaOpened`: set `SldSeek.Maximum`, start timer, call `ApplyCurrentSpeed` in `win/MainWindow.xaml.cs`
- [x] 2.3 Implement `ApplyCurrentSpeed` parsing `CmbSpeed` selected content and setting `VidPreview.SpeedRatio` in `win/MainWindow.xaml.cs`
- [x] 2.4 Add `MediaEnded` handler resetting `VidPreview.Position = TimeSpan.Zero` in `win/MainWindow.xaml.cs`
- [x] 2.5 Implement `VidPreview_MediaFailed` showing warning `MessageBox` in `win/MainWindow.xaml.cs`

## 3. Timer and Seek

- [x] 3.1 Create `DispatcherTimer` with 200ms interval in constructor; implement `Timer_Tick` updating `SldSeek` and `TxtVidTime` when not seeking in `win/MainWindow.xaml.cs`
- [x] 3.2 Implement `SldSeek_DragStarted` setting `_isSeeking=true` in `win/MainWindow.xaml.cs`
- [x] 3.3 Implement `SldSeek_DragCompleted` setting `_isSeeking=false` and applying position in `win/MainWindow.xaml.cs`
- [x] 3.4 Implement `SldSeek_ValueChanged` applying position only when `_isSeeking` in `win/MainWindow.xaml.cs`
- [x] 3.5 Implement `SldVolume_ValueChanged` setting `VidPreview.Volume` in `win/MainWindow.xaml.cs`
- [x] 3.6 Implement `CmbSpeed_SelectionChanged` calling `ApplyCurrentSpeed` in `win/MainWindow.xaml.cs`

## 4. LoadCurrentMedia Video Branch

- [x] 4.1 Add video branch in `LoadCurrentMedia`: detect video extensions, show `VidPreview`, hide `ImgPreview`, set source, call `Play`, show `VidControls` in `win/MainWindow.xaml.cs`
- [x] 4.2 Add image branch cleanup: stop timer, hide `VidControls`, stop and null `VidPreview.Source` in `win/MainWindow.xaml.cs`
