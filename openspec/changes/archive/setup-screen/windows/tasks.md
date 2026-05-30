# Windows Tasks: setup-screen

## 1. XAML Layout

- [x] 1.1 Populate `MenuScreen` StackPanel in `win/MainWindow.xaml` with source folder section (label, `TxtSourcePath`, "Select" button, `ChkRecursive`, `TxtMediaCount`)
- [x] 1.2 Add destination folder section (label, `TxtDestPath`, "Select" button) to `MenuScreen` in `win/MainWindow.xaml`
- [x] 1.3 Add "Begin Sorting" button wired to `Start_Click` in `win/MainWindow.xaml`

## 2. Source Folder Logic

- [x] 2.1 Implement `BrowseSource_Click` using `OpenFolderDialog` in `win/MainWindow.xaml.cs`
- [x] 2.2 Implement `UpdateMediaCount()` calling `_mediaService.GetMediaFiles` and updating `TxtMediaCount` in `win/MainWindow.xaml.cs`
- [x] 2.3 Implement `ChkRecursive_Changed` calling `UpdateMediaCount()` when `IsLoaded` in `win/MainWindow.xaml.cs`

## 3. Destination Folder Logic

- [x] 3.1 Implement `BrowseDest_Click` using `OpenFolderDialog` in `win/MainWindow.xaml.cs`

## 4. Start Validation

- [x] 4.1 Implement `Start_Click` with null/empty check on both paths, showing `MessageBox` on failure in `win/MainWindow.xaml.cs`
- [x] 4.2 Wire successful validation to call `InitializeMediaQueue()` in `win/MainWindow.xaml.cs`
