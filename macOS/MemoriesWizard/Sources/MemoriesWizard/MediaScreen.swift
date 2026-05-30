import SwiftUI
import AppKit
import AVKit

struct MediaScreen: View {
    @Binding var activeScreen: Screen
    @Binding var sourcePath: String
    @Binding var destPath: String
    @Binding var keptFiles: [URL]
    @Binding var skippedFiles: [URL]
    @Binding var trashedFiles: [URL]
    @Binding var unsupportedFiles: [URL]
    @Binding var summaryText: String
    @Binding var isProcessing: Bool

    @EnvironmentObject var mediaService: MediaService

    // Media state
    @State private var mediaFiles: [URL] = []
    @State private var currentIndex: Int = 0
    @State private var image: NSImage?
    @State private var showVideo: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // Jump-to-index
    @State private var jumpIndexText: String = ""
    @FocusState private var isJumpFieldFocused: Bool

    // Swipe gesture state
    @State private var dragOffset: CGSize = .zero
    @State private var dragRotation: Double = 0
    @State private var indicatorText: String = ""
    @State private var indicatorColor: Color = .clear
    @State private var indicatorOpacity: Double = 0

    // Video state
    @StateObject private var playerVM = VideoPlayerViewModel()
    @State private var showControls: Bool = true
    @State private var volume: Float = 0.5

    var body: some View {
        ZStack {
            // Media Container (card area)
            ZStack {
                // Image preview
                if !showVideo, let img = image {
                    Image(nsImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
                }

                // Video preview
                if showVideo {
                    VideoPlayerView(player: playerVM.player)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
                }

                // Empty state
                if image == nil && !showVideo {
                    Text("No media loaded")
                        .font(Theme.headingFont)
                        .foregroundColor(Theme.textSecondary)
                }

                // Swipe indicator overlay
                Text(indicatorText)
                    .font(Theme.indicatorFont)
                    .foregroundColor(indicatorColor)
                    .opacity(indicatorOpacity)
                    .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(40)
            .offset(x: dragOffset.width, y: dragOffset.height)
            .rotationEffect(.degrees(dragRotation))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isProcessing else { return }
                        dragOffset = value.translation
                        dragRotation = value.translation.width / 15
                        updateIndicator(translation: value.translation)
                    }
                    .onEnded { value in
                        guard !isProcessing else { return }
                        let endTranslation = value.predictedEndTranslation
                        let decision = evaluateDragEnd(translation: endTranslation)
                        if decision != nil {
                            flyOffAnimation(decision: decision!)
                        } else {
                            springBackAnimation()
                        }
                    }
            )
            .allowsHitTesting(!isProcessing)

            // Controls overlay (bottom)
            VStack {
                Spacer()

                // Video controls (only for video)
                if showVideo, showControls {
                    VideoControlsView(
                        playerVM: playerVM,
                        volume: $volume
                    )
                    .padding(.horizontal, 40)
                    .padding(.bottom, 8)
                }

                // Media info bar
                HStack {
                    // Filename
                    Text(currentMediaFileName())
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(1)

                    Spacer()

                    // Jump to index
                    TextField("", text: $jumpIndexText)
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textPrimary)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.plain)
                        .padding(4)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .focused($isJumpFieldFocused)
                        .onSubmit {
                            jumpToIndex()
                        }

                    Text("/ \(mediaFiles.count)")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)

                    // Complete Now button
                    Button("Complete Now") {
                        completeNowTapped()
                    }
                    .buttonStyle(Theme.PrimaryButtonStyle())
                    .font(Theme.captionFont)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 16)
            }
        }
        .alert("Media", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
        .onAppear {
            setupKeyboardMonitor()
            if activeScreen == .media {
                initializeMediaQueue()
            }
        }
        .onChange(of: activeScreen) { newScreen in
            if newScreen == .media {
                initializeMediaQueue()
            }
        }
        .onDisappear {
            removeKeyboardMonitor()
        }
    }

    // MARK: - Keyboard Monitoring (macOS 13 compatible)

    class KeyboardMonitor {
        var monitor: Any?
        func setup(handler: @escaping (NSEvent) -> NSEvent?) {
            monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: handler)
        }
        func remove() {
            if let m = monitor {
                NSEvent.removeMonitor(m)
                monitor = nil
            }
        }
    }
    private let keyMonitor = KeyboardMonitor()

    func setupKeyboardMonitor() {
        keyMonitor.setup { [weak keyMonitor] event in
            guard activeScreen == .media, !isProcessing else { return event }

            switch event.keyCode {
            case 124: // Right arrow
                flyOffAnimation(decision: .keep)
                return nil
            case 123: // Left arrow
                flyOffAnimation(decision: .skip)
                return nil
            case 125: // Down arrow
                flyOffAnimation(decision: .trash)
                return nil
            default:
                return event
            }
        }
    }

    func removeKeyboardMonitor() {
        keyMonitor.remove()
    }

    // MARK: - Queue Initialisation

    func initializeMediaQueue() {
        guard !sourcePath.isEmpty else {
            alertMessage = "Invalid source folder path."
            showAlert = true
            return
        }

        let sourceURL = URL(fileURLWithPath: sourcePath)
        let result = mediaService.scanMedia(sourceURL: sourceURL, recursive: true)
        mediaFiles = result.mediaFiles
        unsupportedFiles = result.unsupportedFiles
        keptFiles = []
        skippedFiles = []
        trashedFiles = []
        currentIndex = 0

        guard !mediaFiles.isEmpty else {
            alertMessage = "No media files found in the selected folder."
            showAlert = true
            return
        }

        loadCurrentMedia()
    }

    func advanceToNext() {
        currentIndex += 1
        if currentIndex >= mediaFiles.count {
            showSuccess()
        } else {
            loadCurrentMedia()
        }
    }

    // MARK: - Media Loading

    func loadCurrentMedia() {
        guard currentIndex < mediaFiles.count else { return }

        // Reset animation state
        withAnimation(.none) {
            dragOffset = .zero
            dragRotation = 0
            indicatorOpacity = 0
        }

        let url = mediaFiles[currentIndex]
        let ext = url.pathExtension.lowercased()

        // Stop any existing video
        playerVM.stop()
        showVideo = false
        image = nil

        if ["mp4", "mov", "wmv", "avi"].contains(ext) {
            // Video branch
            showVideo = true
            playerVM.loadVideo(url: url)
            if let speed = UserDefaults.standard.object(forKey: "playbackSpeed") as? Double {
                playerVM.currentSpeed = speed
                playerVM.applyCurrentSpeed()
            }
            showControls = true
        } else {
            // Image branch
            showVideo = false
            loadImage(url: url)
            showControls = false
        }

        jumpIndexText = "\(currentIndex + 1)"
    }

    func loadImage(url: URL) {
        guard let rawImage = NSImage(contentsOf: url) else {
            image = nil
            return
        }

        // Generate thumbnail at max 1200px
        let maxDim: CGFloat = 1200
        let size = rawImage.size
        if size.width > maxDim || size.height > maxDim {
            let scale = min(maxDim / size.width, maxDim / size.height)
            let newSize = NSSize(width: size.width * scale, height: size.height * scale)
            let thumbnail = NSImage(size: newSize)
            thumbnail.lockFocus()
            rawImage.draw(in: NSRect(origin: .zero, size: newSize),
                          from: NSRect(origin: .zero, size: size),
                          operation: .copy, fraction: 1.0)
            thumbnail.unlockFocus()
            image = thumbnail
        } else {
            image = rawImage
        }
    }

    func currentMediaFileName() -> String {
        guard currentIndex < mediaFiles.count else { return "" }
        return mediaFiles[currentIndex].lastPathComponent
    }

    // MARK: - Jump to Index

    func jumpToIndex() {
        guard let index = Int(jumpIndexText), index >= 1, index <= mediaFiles.count else {
            jumpIndexText = "\(currentIndex + 1)"
            return
        }
        currentIndex = index - 1
        loadCurrentMedia()
        isJumpFieldFocused = false
    }

    // MARK: - Swipe Gesture

    func updateIndicator(translation: CGSize) {
        if translation.width > 50 {
            indicatorText = "KEEP"
            indicatorColor = Theme.indicatorKeep
            indicatorOpacity = min(1.0, Double(abs(translation.width)) / 150.0)
        } else if translation.width < -50 {
            indicatorText = "SKIP"
            indicatorColor = Theme.indicatorSkip
            indicatorOpacity = min(1.0, Double(abs(translation.width)) / 150.0)
        } else if translation.height > 50, abs(translation.height) > abs(translation.width) {
            indicatorText = "TRASH"
            indicatorColor = Theme.indicatorTrash
            indicatorOpacity = min(1.0, Double(abs(translation.height)) / 150.0)
        } else {
            indicatorText = ""
            indicatorOpacity = 0
        }
    }

    func evaluateDragEnd(translation: CGSize) -> Decision? {
        let threshold: CGFloat = 150
        if translation.width > threshold {
            return .keep
        } else if translation.width < -threshold {
            return .skip
        } else if translation.height > threshold, abs(translation.height) > abs(translation.width) {
            return .trash
        }
        return nil
    }

    // MARK: - Animations

    func flyOffAnimation(decision: Decision) {
        isProcessing = true
        let targetX: CGFloat
        let targetY: CGFloat

        switch decision {
        case .keep:
            targetX = 600
            targetY = -100
        case .skip:
            targetX = -600
            targetY = -50
        case .trash:
            targetX = 0
            targetY = 600
        }

        withAnimation(.easeOut(duration: 0.3)) {
            dragOffset = CGSize(width: targetX, height: targetY)
            dragRotation = dragRotation * 2
            indicatorOpacity = 1.0

            switch decision {
            case .keep:
                indicatorText = "KEEP"
                indicatorColor = Theme.indicatorKeep
            case .skip:
                indicatorText = "SKIP"
                indicatorColor = Theme.indicatorSkip
            case .trash:
                indicatorText = "TRASH"
                indicatorColor = Theme.indicatorTrash
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            processDecision(decision)
        }
    }

    func springBackAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            dragOffset = .zero
            dragRotation = 0
            indicatorOpacity = 0
        }
    }

    // MARK: - Decision Processing

    func processDecision(_ decision: Decision) {
        guard currentIndex < mediaFiles.count else { return }
        let fileURL = mediaFiles[currentIndex]

        // Stop video playback
        playerVM.stop()
        showVideo = false
        image = nil

        do {
            switch decision {
            case .keep:
                let destDir = URL(fileURLWithPath: destPath)
                try mediaService.moveToDestination(source: fileURL, destDir: destDir)
                keptFiles.append(fileURL)

            case .skip:
                skippedFiles.append(fileURL)

            case .trash:
                try mediaService.sendToTrash(file: fileURL)
                trashedFiles.append(fileURL)
            }
        } catch {
            alertMessage = "Error processing file: \(error.localizedDescription)"
            showAlert = true
        }

        isProcessing = false
        advanceToNext()
    }

    // MARK: - Complete Now

    func completeNowTapped() {
        playerVM.stop()
        showVideo = false
        image = nil
        showSuccess()
    }

    func showSuccess() {
        summaryText = """
        Session Complete!

        Kept: \(keptFiles.count)
        Skipped: \(skippedFiles.count)
        Trashed: \(trashedFiles.count)
        Unsupported: \(unsupportedFiles.count)
        """
        activeScreen = .success
    }
}

// MARK: - Video Controls View

struct VideoControlsView: View {
    @ObservedObject var playerVM: VideoPlayerViewModel
    @Binding var volume: Float

    var body: some View {
        VStack(spacing: 8) {
            // Seek slider
            HStack {
                Text(formatTime(playerVM.currentTime))
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.textSecondary)
                    .frame(width: 50)

                Slider(
                    value: Binding(
                        get: {
                            playerVM.duration.seconds > 0
                                ? playerVM.currentTime.seconds / playerVM.duration.seconds
                                : 0
                        },
                        set: { newValue in
                            let targetTime = CMTime(
                                seconds: playerVM.duration.seconds * newValue,
                                preferredTimescale: 600
                            )
                            playerVM.seek(to: targetTime)
                        }
                    ),
                    onEditingChanged: { editing in
                        playerVM.isSeeking = editing
                    }
                )

                Text(formatTime(playerVM.duration))
                    .font(Theme.captionFont)
                    .foregroundColor(Theme.textSecondary)
                    .frame(width: 50)
            }

            HStack(spacing: 16) {
                // Volume
                HStack(spacing: 4) {
                    Image(systemName: "speaker.fill")
                        .font(.caption)
                        .foregroundColor(Theme.textSecondary)
                    Slider(value: $volume, in: 0...1)
                        .frame(width: 80)
                        .onChange(of: volume) { newVal in
                            playerVM.player?.volume = newVal
                        }
                }

                Spacer()

                // Speed picker
                Picker("Speed", selection: Binding(
                    get: { playerVM.currentSpeed },
                    set: { newSpeed in
                        playerVM.currentSpeed = newSpeed
                        playerVM.applyCurrentSpeed()
                    }
                )) {
                    Text("0.5x").tag(0.5)
                    Text("0.75x").tag(0.75)
                    Text("1x").tag(1.0)
                    Text("1.25x").tag(1.25)
                    Text("1.5x").tag(1.5)
                    Text("2x").tag(2.0)
                }
                .pickerStyle(.menu)
                .frame(width: 80)
            }
        }
        .padding(12)
        .background(Theme.cardBackground.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    func formatTime(_ time: CMTime) -> String {
        guard time.seconds.isFinite else { return "--:--" }
        let totalSeconds = Int(time.seconds)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

