# 🧙‍♂️ Memories Wizard

**Memories Wizard** is a high-performance, 100% native desktop application designed to help you sort through mountains of photos and videos with ease. Inspired by the "Tinder" swiping experience and Apple's iOS glassmorphism aesthetic.

## ✨ Features

- **🚀 Native Performance:** Built with C# WPF (Windows) and SwiftUI (macOS) for hardware-accelerated media playback.
- **💎 Glassmorphism UI:** Beautiful iOS-inspired "frosted glass" interface with nature-inspired accents.
- **🎛️ Intuitive Sorting (Tinder-style):**
  - **Swipe Right / Right Arrow:** Move to Destination (Keep).
  - **Swipe Left / Left Arrow:** Skip.
  - **Swipe Down / Down Arrow:** Send to Recycle Bin (Trash).
- **📁 Smart Media Engine:**
  - Auto-play videos (muted/looped) on load.
  - Optional **Recursive Scanning** to find media hidden in subfolders.
  - Collision protection (automatically renames duplicate filenames in destination).
- **🎯 Session Management:**
  - **Jump to Index:** Type a number to jump directly to a specific photo/video.
  - **Complete Now:** Finish your sorting session early and view your results.
- **🛡️ Robustness:** Built-in retry mechanism to handle file locks from video engines.

## 🖼️ Preview
![Memories Wizard Screenshot](screenshot.png)

## 🗂️ Project Structure

- `win/`: Windows source code (C# WPF).
- `macos/`: macOS source code (SwiftUI).
- `docs/`: Documentation and branding assets.
- `tmp/`: Temporary files, internal tests, and build artifacts.
- `tmp/Publish/Windows/`: Contains the standalone portable executable.

## 🚀 Installation & Running

### Windows
1. Go to `tmp/Publish/Windows/`.
2. Run `MemoriesWizard.exe`.
3. *Note: No installation required! It is a portable standalone file.*

### macOS
1. Copy the `macos/` folder to a Mac.
2. Open `MemoriesWizard.xcodeproj` in **Xcode**.
3. Build and Run.
4. (To package as .dmg, follow instructions in `macos/README_PACKAGING.md`).

## 🛠️ Development

### Windows Requirements
- .NET 8.0 SDK
- Windows 10/11

```powershell
# Run the app
dotnet run

# Build standalone executable
dotnet publish -c Release -r win-x64 --self-contained true -p:PublishSingleFile=true
```

### macOS Requirements
- Xcode 15+
- macOS Sonoma+

## 📄 License
MIT License. Created with ❤️ for organizing memories.
