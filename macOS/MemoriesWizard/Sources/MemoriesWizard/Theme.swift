import SwiftUI
import AppKit

// MARK: - Theme

struct Theme {
    // Colors
    static let backgroundGradientStart = Color(red: 0.05, green: 0.05, blue: 0.15)
    static let backgroundGradientEnd = Color(red: 0.10, green: 0.10, blue: 0.25)
    static let cardBackground = Color(red: 0.12, green: 0.12, blue: 0.22)
    static let accentColor = Color(red: 0.35, green: 0.55, blue: 0.95)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.6)
    static let buttonBackground = Color(red: 0.20, green: 0.20, blue: 0.35)
    static let buttonHover = Color(red: 0.28, green: 0.28, blue: 0.45)
    static let indicatorKeep = Color.green
    static let indicatorSkip = Color.gray
    static let indicatorTrash = Color(red: 0.98, green: 0.50, blue: 0.45) // salmon
    static let successGreen = Color.green

    // Fonts
    static let titleFont = Font.system(size: 24, weight: .bold, design: .rounded)
    static let headingFont = Font.system(size: 18, weight: .semibold, design: .rounded)
    static let bodyFont = Font.system(size: 14, weight: .regular, design: .rounded)
    static let captionFont = Font.system(size: 12, weight: .medium, design: .rounded)
    static let indicatorFont = Font.system(size: 48, weight: .heavy, design: .rounded)

    // Corner Radii
    static let windowCornerRadius: CGFloat = 30
    static let cardCornerRadius: CGFloat = 16
    static let buttonCornerRadius: CGFloat = 10

    // Button Style
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(Theme.bodyFont)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(configuration.isPressed ? Theme.buttonHover : Theme.buttonBackground)
                .foregroundColor(Theme.textPrimary)
                .clipShape(RoundedRectangle(cornerRadius: Theme.buttonCornerRadius))
        }
    }

    struct AccentButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(Theme.bodyFont)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(configuration.isPressed ? Theme.accentColor.opacity(0.7) : Theme.accentColor)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.buttonCornerRadius))
        }
    }
}

// MARK: - Observable theme for environment injection
class ThemeManager: ObservableObject {
    // Placeholder for theme state if needed later
}
