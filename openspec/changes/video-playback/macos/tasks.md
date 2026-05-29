# macOS Tasks: video-playback

## 1. Video Player View

- [ ] 1.1 Create `macOS/MemoriesWizard/VideoPlayerView.swift` as `NSViewRepresentable` wrapping `AVPlayerView` with `controlsStyle = .none`
- [ ] 1.2 Add `VidPreview` `VideoPlayerView` inside `MediaContainer` with visibility controlled by `showVideo`

## 2. Video Controls Overlay

- [ ] 2.1 Add `VidControls` `VStack` overlay (`alignment: .bottom`, initially hidden via `showControls`) with seek, time, volume, and speed controls in `MediaScreen.swift`
- [ ] 2.2 Add `SldSeek` `Slider` with `onEditingChanged` (`isSeeking`) and `onCommit` in `MediaScreen.swift`
- [ ] 2.3 Add `TxtVidTime` `Text`, `SldVolume` `Slider` (0...1, default 0.5), `CmbSpeed` `Picker` (0.5x/0.75x/1.0x/1.25x/1.5x/2.0x, default 1.0x) in `MediaScreen.swift`

## 3. Playback Logic

- [ ] 3.1 Create `@StateObject var playerVM = VideoPlayerViewModel()` holding `AVPlayer`, `AVPlayerLooper`, `@Published isSeeking`, `@Published currentSpeed`
- [ ] 3.2 Implement `loadVideo(url:)` in `VideoPlayerViewModel`: create `AVPlayerItem`, set up `AVPlayerLooper` for seamless looping, observe `status` for ready-to-play
- [ ] 3.3 Implement `applyCurrentSpeed` parsing `CmbSpeed` selection and setting `AVPlayer.rate` in `VideoPlayerViewModel`
- [ ] 3.4 Add notification observer for `.AVPlayerItemDidPlayToEndTime` (redundant with looper, but ensures loop if looper configuration fails) in `VideoPlayerViewModel`
- [ ] 3.5 Add `AVPlayerItem.status` observation for error handling; surface errors via `@Published var errorMessage: String?`

## 4. Timer and Seek

- [ ] 4.1 Create `Timer.publish(every: 0.2)` in `VideoPlayerViewModel`; update `@Published currentTime` and `@Published duration` when not `isSeeking`
- [ ] 4.2 Implement `SldSeek` `onEditingChanged`: set `isSeeking = true` on drag start, `isSeeking = false` + `player.seek(to: CMTime)` on commit
- [ ] 4.3 Implement `SldVolume` `onChange`: set `player.volume` from Float value
- [ ] 4.4 Implement `CmbSpeed` `onChange`: call `applyCurrentSpeed`
- [ ] 4.5 Persist speed selection via `@AppStorage("playbackSpeed")` so it's re-applied on new video load

## 5. LoadCurrentMedia Video Branch

- [ ] 5.1 Add video branch in `loadCurrentMedia`: detect video extensions (`.mp4`, `.mov`, `.wmv`, `.avi`), show `VidPreview`, hide `ImgPreview`, call `playerVM.loadVideo(url:)`, show `VidControls`
- [ ] 5.2 Add image branch cleanup: stop timer, hide `VidControls`, call `playerVM.stop()` and nil the player item
