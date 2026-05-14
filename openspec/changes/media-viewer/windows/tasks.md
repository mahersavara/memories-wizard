# Windows Tasks: media-viewer

## 1. MediaScreen XAML

- [x] 1.1 Add `MediaContainer` Border with `TransformGroup` (`TranslateTransform` + `RotateTransform`) in `win/MainWindow.xaml`
- [x] 1.2 Add `ImgPreview` Image (`Stretch=Uniform`) inside `MediaContainer` in `win/MainWindow.xaml`
- [x] 1.3 Add `TxtFileName` TextBlock, `TxtCurrentIndex` editable TextBox (with `KeyDown` event), and `TxtTotalCount` TextBlock in `win/MainWindow.xaml`

## 2. Queue Initialisation

- [x] 2.1 Implement `InitializeMediaQueue` in `win/MainWindow.xaml.cs`: call scan, check empty, set counter, transition screens
- [x] 2.2 Implement `ShowNextMedia` advancing `_currentIndex` and calling `ShowSuccess` when exhausted in `win/MainWindow.xaml.cs`

## 3. Image Loading

- [x] 3.1 Implement image branch in `LoadCurrentMedia`: create `BitmapImage` with `CacheOption.OnLoad` and `DecodePixelWidth=1000` in `win/MainWindow.xaml.cs`
- [x] 3.2 Reset `MediaTransform.X/Y`, `MediaRotate.Angle`, and `TxtIndicator.Opacity` at start of `LoadCurrentMedia`

## 4. Jump to Index

- [x] 4.1 Implement `TxtCurrentIndex_KeyDown`: parse input, validate range, navigate or restore on invalid in `win/MainWindow.xaml.cs`
