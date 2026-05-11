import Foundation
import AppKit

protocol MediaServiceProtocol {
    func getMediaFiles(from sourceURL: URL, recursive: Bool) -> [URL]
    func moveToDestination(file: URL, to destinationURL: URL) throws
    func sendToTrash(file: URL) throws
}

class MediaService: MediaServiceProtocol {
    private let mediaExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "mp4", "mov", "avi"]
    
    func getMediaFiles(from sourceURL: URL, recursive: Bool) -> [URL] {
        let fileManager = FileManager.default
        let options: FileManager.DirectoryEnumerationOptions = recursive ? [.skipsHiddenFiles] : [.skipsHiddenFiles, .skipsSubdirectoryDescendants]
        
        guard let enumerator = fileManager.enumerator(at: sourceURL, 
                                                   includingPropertiesForKeys: [.isRegularFileKey], 
                                                   options: options) else {
            return []
        }
        
        var mediaFiles: [URL] = []
        for case let fileURL as URL in enumerator {
            let fileName = fileURL.lastPathComponent
            if !fileName.hasPrefix(".") && mediaExtensions.contains(fileURL.pathExtension.lowercased()) {
                mediaFiles.append(fileURL)
            }
        }
        return mediaFiles
    }
    
    func moveToDestination(file: URL, to destinationURL: URL) throws {
        let fileManager = FileManager.default
        let destFile = destinationURL.appendingPathComponent(file.lastPathComponent)
        
        // Handle name collision
        var finalDest = destFile
        if fileManager.fileExists(atPath: destFile.path) {
            let uniqueName = "\(UUID().uuidString)_\(file.lastPathComponent)"
            finalDest = destinationURL.appendingPathComponent(uniqueName)
        }
        
        try fileManager.moveItem(at: file, to: finalDest)
    }
    
    func sendToTrash(file: URL) throws {
        try FileManager.default.trashItem(at: file, resultingItemURL: nil)
    }
}
