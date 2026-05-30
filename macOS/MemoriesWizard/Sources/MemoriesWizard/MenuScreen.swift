import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct MenuScreen: View {
    @Binding var activeScreen: Screen
    @Binding var sourcePath: String
    @Binding var destPath: String

    @EnvironmentObject var mediaService: MediaService

    @State private var mediaCount: Int = 0
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @AppStorage("recursiveScan") private var recursive: Bool = true

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // App Title
            Text("Memories Wizard")
                .font(Theme.titleFont)
                .foregroundColor(Theme.textPrimary)

            Text("Sort through your photos and videos with a swipe")
                .font(Theme.captionFont)
                .foregroundColor(Theme.textSecondary)

            Spacer().frame(height: 16)

            // Source Folder Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Source Folder")
                    .font(Theme.headingFont)
                    .foregroundColor(Theme.textPrimary)

                HStack {
                    Text(sourcePath.isEmpty ? "No folder selected..." : sourcePath)
                        .font(Theme.bodyFont)
                        .foregroundColor(sourcePath.isEmpty ? Theme.textSecondary : Theme.textPrimary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Button("Select Source", action: browseSource)
                        .buttonStyle(Theme.PrimaryButtonStyle())
                }

                Toggle(isOn: $recursive) {
                    Text("Include subfolders")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                }
                .toggleStyle(.checkbox)
                .onChange(of: recursive) { _ in updateMediaCount() }

                Text("\(mediaCount) media files found")
                    .font(Theme.captionFont)
                    .foregroundColor(mediaCount > 0 ? Theme.successGreen : Theme.textSecondary)
            }
            .padding(20)
            .background(Theme.cardBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

            // Destination Folder Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Destination Folder")
                    .font(Theme.headingFont)
                    .foregroundColor(Theme.textPrimary)

                HStack {
                    Text(destPath.isEmpty ? "No folder selected..." : destPath)
                        .font(Theme.bodyFont)
                        .foregroundColor(destPath.isEmpty ? Theme.textSecondary : Theme.textPrimary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Theme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Button("Select Destination", action: browseDest)
                        .buttonStyle(Theme.PrimaryButtonStyle())
                }
            }
            .padding(20)
            .background(Theme.cardBackground.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

            Spacer()

            // Begin Sorting Button
            Button("Begin Sorting", action: startSorting)
                .buttonStyle(Theme.AccentButtonStyle())
                .font(Theme.headingFont)
                .disabled(sourcePath.isEmpty || destPath.isEmpty)
                .opacity((sourcePath.isEmpty || destPath.isEmpty) ? 0.5 : 1.0)

            Spacer().frame(height: 20)
        }
        .padding(.horizontal, 60)
        .alert("Setup", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Source Folder Logic

    func browseSource() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Select the folder containing your media files"

        if panel.runModal() == .OK {
            sourcePath = panel.url?.path ?? ""
            updateMediaCount()
        }
    }

    func updateMediaCount() {
        guard !sourcePath.isEmpty else {
            mediaCount = 0
            return
        }
        let result = mediaService.scanMedia(sourceURL: URL(fileURLWithPath: sourcePath), recursive: recursive)
        DispatchQueue.main.async {
            mediaCount = result.mediaFiles.count
        }
    }

    // MARK: - Destination Folder Logic

    func browseDest() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.message = "Select folder where kept media will be moved"

        if panel.runModal() == .OK {
            destPath = panel.url?.path ?? ""
        }
    }

    // MARK: - Start Validation

    func startSorting() {
        guard !sourcePath.isEmpty, !destPath.isEmpty else {
            alertMessage = "Please select both folders."
            showAlert = true
            return
        }

        guard mediaCount > 0 else {
            alertMessage = "No media files found in the selected source folder."
            showAlert = true
            return
        }

        activeScreen = .media
    }
}

