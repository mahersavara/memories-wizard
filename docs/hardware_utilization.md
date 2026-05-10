# 🖥️ Hardware Utilization: GPU vs CPU

This document provides a technical breakdown of how **Memories Wizard** utilizes your system's hardware to ensure a high-performance, premium user experience.

## 🚀 Strategy: GPU-Heavy Architecture

The application is designed to be **GPU-heavy**, offloading visually intensive tasks to your graphics hardware. This ensures that the interface remains responsive (60/120 FPS) and the CPU remains available for file system operations.

---

## 🎨 GPU Utilization

### 1. Video Playback (Hardware Acceleration)
- **Technology:** Windows Media Foundation (WMF).
- **Mechanism:** When a video is played, the app triggers **DirectX Video Acceleration (DXVA)**. This uses dedicated hardware decoders on your GPU to process H.264, H.265 (HEVC), and VP9 codecs.
- **Benefit:** Ultra-low CPU usage (usually 1-3%) even for 4K video, preventing system heat and battery drain.

### 2. Image Rendering
- **Technology:** WPF DirectX Pipeline.
- **Mechanism:** Images are loaded into memory and rendered as textures using DirectX. Scaling and color processing are handled by GPU shaders.
- **Optimization:** We use `BitmapCacheOption.OnLoad` to ensure images are fully decoded into memory once, allowing the GPU to redraw them instantly without disk I/O.

### 3. UI Animations & Effects
- **Technology:** Windows Composition Engine.
- **Mechanism:** Tinder-style swiping, rotations (Tilt), fly-off animations, and **Glassmorphism** (Mica/Acrylic) effects are processed directly by the GPU's composition layer.
- **Benefit:** Guarantees frame-perfect animations without "jank" or lag.

---

## ⚙️ CPU Utilization

The CPU is reserved for logic-heavy and I/O-heavy tasks that cannot be effectively parallelized on a GPU.

### 1. File System Operations
- **Scanning:** Recursively crawling through directories to identify media files.
- **Moving/Sorting:** Coordinating with the OS Kernel to perform `File.Move` operations across storage volumes.
- **Trash:** Managing the interaction with the Windows Recycle Bin or hidden `.trash` folders.

### 2. Logic & Event Handling
- Handling user input (keyboard/mouse), processing "Jump to Index" requests, and managing the state transition between screens.

---

## 📊 Summary Table

| Task | Primary Hardware | Technology |
| :--- | :--- | :--- |
| **Video Decoding** | **GPU** | WMF / DXVA |
| **Image Display** | **GPU** | DirectX |
| **Swiping Animations** | **GPU** | Composition Engine |
| **Glassmorphism Blur** | **GPU** | Pixel Shaders |
| **Folder Scanning** | **CPU** | .NET Runtime |
| **File Moving** | **CPU / Disk** | OS Kernel |

---
*Technical Analysis by the Memories Wizard Team*
