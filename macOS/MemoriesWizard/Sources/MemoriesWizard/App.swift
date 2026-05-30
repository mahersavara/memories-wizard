import SwiftUI
import AppKit

// MARK: - Crash Handler

func setupCrashHandlers() {
    // Obj-C exception handler
    NSSetUncaughtExceptionHandler { exception in
        let message = "Unhandled exception: \(exception.name.rawValue)\nReason: \(exception.reason ?? "unknown")\n\(exception.callStackSymbols.joined(separator: "\n"))"
        writeCrashLog(message)
        showCrashAlert(message)
    }

    // Signal handler for Swift runtime errors
    let signals: [Int32] = [SIGILL, SIGTRAP, SIGABRT]
    for sig in signals {
        signal(sig) { signalValue in
            let message = "Fatal signal: \(signalValue)\n\(Thread.callStackSymbols.joined(separator: "\n"))"
            writeCrashLog(message)
            showCrashAlert(message)
        }
    }
}

func writeCrashLog(_ message: String) {
    let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    let appDir = appSupport.appendingPathComponent("MemoriesWizard")
    try? FileManager.default.createDirectory(at: appDir, withIntermediateDirectories: true)
    let logFile = appDir.appendingPathComponent("crash.log")
    let entry = "=== \(Date()) ===\n\(message)\n\n"
    if let handle = try? FileHandle(forWritingTo: logFile) {
        handle.seekToEndOfFile()
        handle.write(entry.data(using: .utf8)!)
        handle.closeFile()
    } else {
        try? entry.write(to: logFile, atomically: true, encoding: .utf8)
    }
}

func showCrashAlert(_ message: String) {
    let alert = NSAlert()
    alert.messageText = "Unexpected Error"
    alert.informativeText = "An unexpected error occurred.\n\n\(message)\n\nA crash log has been written to ~/Library/Application Support/MemoriesWizard/crash.log"
    alert.alertStyle = .critical
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

// MARK: - App Delegate (frameless window)

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let window = NSApp.windows.first else { return }
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.styleMask.insert(.fullSizeContentView)

            // Default size 1000x700, centered
            let screenFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)
            let windowWidth: CGFloat = 1000
            let windowHeight: CGFloat = 700
            let originX = screenFrame.midX - windowWidth / 2
            let originY = screenFrame.midY - windowHeight / 2
            window.setFrame(NSRect(x: originX, y: originY, width: windowWidth, height: windowHeight), display: true)
        }
    }
}

// MARK: - App Entry Point

@main
struct MemoriesWizardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        setupCrashHandlers()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 500)
        }
    }
}
