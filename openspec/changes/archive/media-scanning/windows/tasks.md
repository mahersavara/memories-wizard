# Windows Tasks: media-scanning

## 1. Service Definition

- [x] 1.1 Create `win/MediaService.cs` with `IMediaService` interface declaring `GetMediaFiles`, `MoveToDestination`, `SendToRecycleBin`
- [x] 1.2 Add `MediaScanResult` class with `MediaFiles` and `UnsupportedFiles` list properties
- [x] 1.3 Add `Decision` enum (`Keep`, `Skip`, `Trash`) in `win/MediaService.cs`

## 2. MediaService Implementation

- [x] 2.1 Implement `GetMediaFiles` with path/existence guard returning empty result on invalid input
- [x] 2.2 Add `MediaExtensions` static array: `.jpg`, `.jpeg`, `.png`, `.gif`, `.bmp`, `.mp4`, `.mov`, `.wmv`, `.avi`
- [x] 2.3 Implement dot-prefix hidden file exclusion in the enumeration loop
- [x] 2.4 Partition files into `MediaFiles` vs `UnsupportedFiles` based on extension match

## 3. Integration

- [x] 3.1 Instantiate `IMediaService _mediaService = new MediaService()` in `win/MainWindow.xaml.cs`
