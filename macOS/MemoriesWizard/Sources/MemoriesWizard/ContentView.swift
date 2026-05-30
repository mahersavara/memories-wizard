import SwiftUI
import AppKit

// MARK: - Screen Enum

enum Screen: Equatable {
    case menu
    case media
    case success
}

// MARK: - Content View

struct ContentView: View {
    @State private var activeScreen: Screen = .menu
    @StateObject private var mediaService = MediaService()
    @StateObject private var themeManager = ThemeManager()

    // Session data passed between screens
    @State var sourcePath: String = ""
    @State var destPath: String = ""
    @State var keptFiles: [URL] = []
    @State var skippedFiles: [URL] = []
    @State var trashedFiles: [URL] = []
    @State var unsupportedFiles: [URL] = []
    @State var summaryText: String = ""

    // Keyboard control state
    @State private var isProcessing: Bool = false

    var body: some View {
        ZStack {
            // Rounded window shape
            RoundedRectangle(cornerRadius: Theme.windowCornerRadius)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Theme.backgroundGradientStart, Theme.backgroundGradientEnd]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Title Bar
                TitleBar()

                // Screen Content
                ZStack {
                    MenuScreen(
                        activeScreen: $activeScreen,
                        sourcePath: $sourcePath,
                        destPath: $destPath
                    )
                    .opacity(activeScreen == .menu ? 1 : 0)
                    .disabled(activeScreen != .menu)

                    MediaScreen(
                        activeScreen: $activeScreen,
                        sourcePath: $sourcePath,
                        destPath: $destPath,
                        keptFiles: $keptFiles,
                        skippedFiles: $skippedFiles,
                        trashedFiles: $trashedFiles,
                        unsupportedFiles: $unsupportedFiles,
                        summaryText: $summaryText,
                        isProcessing: $isProcessing
                    )
                    .opacity(activeScreen == .media ? 1 : 0)
                    .disabled(activeScreen != .media)

                    SuccessScreen(
                        activeScreen: $activeScreen,
                        summaryText: $summaryText,
                        destPath: $destPath
                    )
                    .opacity(activeScreen == .success ? 1 : 0)
                    .disabled(activeScreen != .success)
                }
                .animation(.easeInOut(duration: 0.25), value: activeScreen)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.windowCornerRadius))
        .environmentObject(mediaService)
        .environmentObject(themeManager)
    }
}

// MARK: - Title Bar

struct TitleBar: View {
    var body: some View {
        HStack(spacing: 0) {
            // Window icon
            Image(nsImage: NSImage(named: NSImage.applicationIconName) ?? NSImage())
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 16)

            // App title
            Text("Memories Wizard")
                .font(Theme.headingFont)
                .foregroundColor(Theme.textPrimary)
                .padding(.leading, 10)

            Spacer()

            // Window control buttons
            HStack(spacing: 8) {
                // Minimize
                Button(action: {
                    NSApp.keyWindow?.miniaturize(nil)
                }) {
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 14, height: 14)
                }
                .buttonStyle(.plain)
                .help("Minimize")

                // Maximize / Restore
                Button(action: {
                    NSApp.keyWindow?.toggleFullScreen(nil)
                }) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 14, height: 14)
                }
                .buttonStyle(.plain)
                .help("Maximize")

                // Close
                Button(action: {
                    NSApp.terminate(nil)
                }) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 14, height: 14)
                }
                .buttonStyle(.plain)
                .help("Close")
            }
            .padding(.trailing, 16)
        }
        .frame(height: 50)
        .background(TitleBarDragView())
    }
}

// MARK: - Title Bar Drag (NSViewRepresentable for proper window dragging)

struct TitleBarDragView: NSViewRepresentable {
    func makeNSView(context: Context) -> DragNSView {
        DragNSView()
    }

    func updateNSView(_ nsView: DragNSView, context: Context) {}

    class DragNSView: NSView {
        override func mouseDown(with event: NSEvent) {
            window?.performDrag(with: event)
        }

        override var acceptsFirstResponder: Bool { true }
    }
}
