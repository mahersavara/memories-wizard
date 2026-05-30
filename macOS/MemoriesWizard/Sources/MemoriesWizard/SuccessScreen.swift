import SwiftUI
import AppKit

struct SuccessScreen: View {
    @Binding var activeScreen: Screen
    @Binding var summaryText: String
    @Binding var destPath: String

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Success icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(Theme.successGreen)

            Text("Session Complete!")
                .font(Theme.titleFont)
                .foregroundColor(Theme.textPrimary)

            // Summary counts
            Text(summaryText)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(20)
                .background(Theme.cardBackground.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))

            Spacer().frame(height: 20)

            // Action buttons
            HStack(spacing: 20) {
                Button("View Collection", action: openDestFolder)
                    .buttonStyle(Theme.AccentButtonStyle())

                Button("Restart", action: backToMenu)
                    .buttonStyle(Theme.PrimaryButtonStyle())
            }

            Spacer()
        }
        .padding(.horizontal, 60)
    }

    func backToMenu() {
        activeScreen = .menu
    }

    func openDestFolder() {
        guard !destPath.isEmpty else { return }
        NSWorkspace.shared.open(URL(fileURLWithPath: destPath))
    }
}

