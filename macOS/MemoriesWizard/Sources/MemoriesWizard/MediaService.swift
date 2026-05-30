import Foundation

// MARK: - Decision Enum

enum Decision {
    case keep
    case skip
    case trash
}

// MARK: - Media Scan Result

struct MediaScanResult {
    var mediaFiles: [URL] = []
    var unsupportedFiles: [URL] = []
}

// MARK: - Media Service Protocol

protocol MediaServiceProtocol {
    func scanMedia(sourceURL: URL?, recursive: Bool) -> MediaScanResult
}

// MARK: - Media Service

class MediaService: ObservableObject, MediaServiceProtocol {
    static let mediaExtensions: Set<String> = [
        "jpg", "jpeg", "png", "gif", "bmp",
        "mp4", "mov", "wmv", "avi"
    ]

    @Published var mediaFiles: [URL] = []
    @Published var unsupportedFiles: [URL] = []

    func scanMedia(sourceURL: URL?, recursive: Bool) -> MediaScanResult {
        guard let sourceURL = sourceURL else {
            return MediaScanResult()
        }

        var isDirectory: ObjCBool = false
        guard FileManager.default.fileExists(atPath: sourceURL.path, isDirectory: &isDirectory),
              isDirectory.boolValue else {
            return MediaScanResult()
        }

        let enumerator = FileManager.default.enumerator(
            at: sourceURL,
            includingPropertiesForKeys: [.isDirectoryKey, .isHiddenKey],
            options: recursive ? [.skipsHiddenFiles] : [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
        )

        var mediaFiles: [URL] = []
        var unsupportedFiles: [URL] = []

        while let url = enumerator?.nextObject() as? URL {
            // Skip hidden files
            guard !url.lastPathComponent.hasPrefix(".") else { continue }

            // Skip directories
            if let resourceValues = try? url.resourceValues(forKeys: [.isDirectoryKey]),
               resourceValues.isDirectory == true {
                continue
            }

            let ext = url.pathExtension.lowercased()
            if Self.mediaExtensions.contains(ext) {
                mediaFiles.append(url)
            } else {
                unsupportedFiles.append(url)
            }
        }

        DispatchQueue.main.async {
            self.mediaFiles = mediaFiles
            self.unsupportedFiles = unsupportedFiles
        }

        return MediaScanResult(mediaFiles: mediaFiles, unsupportedFiles: unsupportedFiles)
    }

    // MARK: - File Operations (decision-processing)

    func moveToDestination(source: URL, destDir: URL) throws {
        guard FileManager.default.fileExists(atPath: source.path) else {
            throw MediaServiceError.fileNotFound
        }
        try FileManager.default.createDirectory(at: destDir, withIntermediateDirectories: true)
        let destFile = destDir.appendingPathComponent(source.lastPathComponent)
        let resolvedDest = resolveCollision(for: destFile)
        try executeWithRetry {
            try FileManager.default.moveItem(at: source, to: resolvedDest)
        }
    }

    func sendToTrash(file: URL) throws {
        guard FileManager.default.fileExists(atPath: file.path) else {
            throw MediaServiceError.fileNotFound
        }
        var resultingItemURL: NSURL?
        do {
            try FileManager.default.trashItem(at: file, resultingItemURL: &resultingItemURL)
        } catch {
            // Fallback: move to .trash subfolder
            let trashDir = file.deletingLastPathComponent().appendingPathComponent(".trash")
            try FileManager.default.createDirectory(at: trashDir, withIntermediateDirectories: true)
            let trashDest = trashDir.appendingPathComponent(file.lastPathComponent)
            try FileManager.default.moveItem(at: file, to: resolveCollision(for: trashDest))
        }
    }

    // MARK: - Helpers

    private func executeWithRetry(block: () throws -> Void) throws {
        var lastError: Error?
        for _ in 0..<5 {
            do {
                try block()
                return
            } catch {
                lastError = error
                Thread.sleep(forTimeInterval: 0.2)
            }
        }
        throw lastError ?? MediaServiceError.retryExhausted
    }

    private func resolveCollision(for url: URL) -> URL {
        let ext = url.pathExtension
        let baseName = url.deletingPathExtension().lastPathComponent
        let dir = url.deletingPathExtension().deletingLastPathComponent()
        var candidate = url
        var counter = 1

        while FileManager.default.fileExists(atPath: candidate.path) {
            let uuidPrefix = UUID().uuidString.prefix(8)
            let newName = "\(baseName)_\(uuidPrefix)"
            candidate = dir.appendingPathComponent(newName).appendingPathExtension(ext)
            counter += 1
            if counter > 100 { break }
        }
        return candidate
    }
}

enum MediaServiceError: LocalizedError {
    case fileNotFound
    case retryExhausted

    var errorDescription: String? {
        switch self {
        case .fileNotFound: return "File not found."
        case .retryExhausted: return "Operation failed after multiple retries."
        }
    }
}
