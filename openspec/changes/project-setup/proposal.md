# project-setup

## Why
The Memories Wizard project requires a documented, reproducible build foundation for both Windows (C#/WPF) and macOS (Swift/SwiftUI) platforms. Establishing the project structure and build configuration enables all subsequent feature changes to reference a stable foundation.

## What Changes
- Platform project files and build configuration for each target platform
- Application entry point and bootstrap with global resource definitions
- Platform-specific dependencies declared for file system utilities
- Resource directory structure for icons and static assets
- Global visual styles and theming configured at application level

## Non-Goals
- No business logic or feature implementation
- No media scanning or file operations
- No UI screens beyond bare application launch

## Capabilities

### New Capabilities
- `project-setup` — Windows, macOS: initial project structure, dependencies, and application bootstrap

### Modified Capabilities
*(none)*

## Impact
Establishes the build foundation that all subsequent changes depend on.
