# 📺 Video Engine: Architecture & Optimization

This document outlines the current technical implementation of the video engine in **Memories Wizard** and proposes advanced optimizations for future versions.

## 🏗️ Current Implementation

The Windows application currently utilizes **WPF MediaElement** as its primary playback engine.

### Core Technologies:
- **Engine:** Windows Media Foundation (WMF).
- **Decoding:** Full Hardware Acceleration (GPU) for common codecs (H.264, H.265/HEVC).
- **Control Mode:** `LoadedBehavior="Manual"` to minimize background overhead.

### Performance Benefits:
- **Power Efficiency:** Leverages native OS-level media pipes.
- **Low CPU Usage:** Offloads heavy decoding tasks to the GPU.
- **On-Demand Loading:** Only initializes the media engine when the file is displayed.

---

## 🏎️ Performance Optimization Proposal

To achieve a "Zero Latency" experience during high-speed swiping, we propose upgrading to a **Dual-Engine Preloading System**.

### The Problem:
Currently, when a user swipes a video, there is a tiny "initialization gap" (usually 100-300ms) where the next video must be opened, its header read, and the first frame rendered.

### The Solution:
Implement a **hidden background buffer** using a second media engine instance.

#### 1. Dual-Engine Architecture
- **Active Engine:** The engine currently visible to the user.
- **Buffer Engine:** A secondary, invisible engine that pre-loads the *next* video in the queue.

#### 2. Transition Workflow
1. User is viewing `Video 1` (Active Engine).
2. The app automatically tells the **Buffer Engine** to load `Video 2` in the background.
3. User swipes `Video 1`.
4. The app instantly swaps the visibility of the two engines.
5. `Video 2` (already sitting at Frame 0) starts playing immediately with zero delay.
6. The old Active Engine is cleared and starts pre-loading `Video 3`.

#### 3. Smart Resource Management
- **Memory Capping:** Only 1 file is preloaded at a time to keep RAM usage low.
- **Visibility Toggling:** Uses Z-index and Opacity for instantaneous UI swaps.

---

## 📊 Comparison

| Feature | Current Engine | Proposed Preloading |
| :--- | :--- | :--- |
| **Transition Delay** | ~250ms | **<10ms (Instant)** |
| **GPU Usage** | Optimized | Slightly higher (during pre-buffering) |
| **RAM Usage** | Minimal (~150MB) | Moderate (~300MB) |
| **UI Snappiness** | Good | **Premium/App-like** |

---
*Technical Strategy by the Memories Wizard Team*
