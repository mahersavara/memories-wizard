# 🖥️ Performance Guidelines

## Recommendation

- Use native OS media, imaging, animation, and file APIs on each platform.
- Target a smooth **60 FPS** interaction model for swiping, transitions, and media changes.
- Prefer simple transform-based animations over heavy visual effects.
- Decode images to the displayed size instead of always loading full-resolution assets.
- Keep the active media set small in memory.
- Use the OS playback stack instead of building a custom video pipeline.

---

## Windows

### Video Playback
- Use **Windows Media Foundation** through WPF's native media stack.
- Preferred APIs:
  - `MediaElement`
  - `MediaPlayer`
- Let **Media Foundation** handle codec selection and hardware acceleration.
- Treat **H.264 MP4/MOV** playback as the baseline path.
- Keep one active playback surface by default.

### Image Decode and Rendering
- Use **Windows Imaging Component (WIC)** through WPF imaging APIs.
- Preferred APIs:
  - `BitmapImage`
  - `BitmapDecoder`
  - `BitmapSource`
- Set `DecodePixelWidth` or `DecodePixelHeight` for preview-sized rendering.
- Use `BitmapCacheOption.OnLoad` when the displayed file may be moved, deleted, or released immediately after loading.
- This fully decodes the image into memory, avoids file locks, and trades disk dependency for higher bitmap memory usage.

### UI Animation
- Use WPF transform-based animation.
- Preferred APIs:
  - `RenderTransform`
  - `TranslateTransform`
  - `RotateTransform`
  - `DoubleAnimation`
  - `Storyboard`
- Animate:
  - translate
  - rotate
  - opacity
- Avoid layout-driven animation when a render transform can do the same work.

### File Operations
- Use native .NET file APIs plus Windows recycle bin integration.
- Preferred APIs:
  - `Directory.EnumerateFiles`
  - `File.Move`
  - `Microsoft.VisualBasic.FileIO.FileSystem.DeleteFile(..., RecycleOption.SendToRecycleBin)`

---

## macOS

### Video Playback
- Use **AVFoundation** for playback.
- Preferred APIs:
  - `AVPlayer`
  - `AVPlayerItem`
  - `AVPlayerLayer`
  - SwiftUI `VideoPlayer` for basic playback UI without frame-level control, preloading, or multi-instance playback management.
- Let **AVFoundation** manage hardware decode automatically.
- Treat **H.264 MP4/MOV** playback as the baseline path.
- Keep one active player by default.

### Image Decode and Rendering
- Use **Image I/O** for image decode.
- Preferred APIs:
  - `CGImageSource`
  - `CGImageSourceCreateThumbnailAtIndex`
  - `NSImage`
  - `Image(nsImage:)`
- Generate preview-sized thumbnails for browsing views.
- Avoid full-resolution decode for every image during normal card navigation.

### UI Animation
- Use **SwiftUI** animations backed by **Core Animation**.
- Preferred APIs:
  - `withAnimation`
  - `offset`
  - `rotationEffect`
  - `opacity`
- Use **`NSVisualEffectView`** only for targeted system blur/translucency surfaces.
- Keep transitions limited to swipe motion, rotation, and fades.

### File Operations
- Use native macOS file management APIs.
- Preferred APIs:
  - `FileManager.enumerator`
  - `FileManager.moveItem`
  - `FileManager.trashItem`

---

## Cross-Platform Rules

- Keep media browsing **OS-API-first**.
- Keep animation **transform-first**.
- Keep image loading **display-size-first**.
- Keep memory usage bounded to current and near-current items.
- Keep codec support expectations centered on broadly supported system codecs.
- Keep a single active playback surface/player by default.
- Consider preloading the next media item only if next-item open latency consistently exceeds **200 ms** or swipe transitions visibly stutter during normal local playback; use **200 ms** as the cutoff to keep media changes feeling immediate during 60 FPS interaction.
- Avoid custom GPU engines, custom decoders, and custom rendering pipelines unless profiling proves they are required.

---

## API Summary

| Area | Windows | macOS |
| :--- | :--- | :--- |
| Video playback | `MediaElement` / `MediaPlayer` on Media Foundation | `AVPlayer` / `AVPlayerItem` / `AVPlayerLayer` / `VideoPlayer` |
| Image decode | `BitmapImage` / `BitmapDecoder` / `BitmapSource` on WIC | `CGImageSource` / `CGImageSourceCreateThumbnailAtIndex` / `NSImage` |
| Animation | `RenderTransform` / `TranslateTransform` / `RotateTransform` / `Storyboard` | `withAnimation` / `offset` / `rotationEffect` / Core Animation |
| File handling | `Directory.EnumerateFiles` / `File.Move` / recycle bin API | `FileManager.enumerator` / `moveItem` / `trashItem` |

---

*Performance recommendation for Memories Wizard*
