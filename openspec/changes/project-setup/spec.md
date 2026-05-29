# Spec: project-setup

## ADDED Requirements

### Requirement: Application project is buildable from a clean checkout
The application project SHALL declare all required SDK settings and dependencies so a clean checkout can build without manual edits.

#### Scenario: Project builds successfully
- **WHEN** a developer runs the platform build command in the app project directory
- **THEN** the project compiles without dependency or SDK configuration errors

### Requirement: File-operation dependencies are declared
The project SHALL include any runtime/library dependencies required by file operations used by the app.

#### Scenario: NuGet dependency resolves
- **WHEN** project dependencies are restored
- **THEN** all required packages resolve and are available to the build

### Requirement: Application entry point initialises shared UI resources
The application entry point SHALL load shared visual resources so common styles are available globally.

#### Scenario: App launches with styles available
- **WHEN** the application starts
- **THEN** shared style references resolve without runtime resource errors

### Requirement: Application metadata supports UI resource discovery
Project metadata SHALL include the required settings for framework-level resource discovery.

#### Scenario: UI metadata is present
- **WHEN** the project is built
- **THEN** framework resource lookup works without runtime metadata errors

### Requirement: Resources directory contains app icon assets
A resources directory SHALL include icon assets used by the app shell and packaged application.

#### Scenario: App icon loads in shell
- **WHEN** the application window is displayed
- **THEN** the shell UI shows the configured icon asset

### Requirement: Packaged app includes an embedded application icon
Build configuration SHALL embed an application icon in packaged binaries.

#### Scenario: Packaged binary carries application icon
- **WHEN** the project is built
- **THEN** the resulting application binary displays the configured icon in the host operating system UI

### Requirement: Global unhandled-exception handler writes a crash log and notifies the user
The app startup path SHALL register a global unhandled-exception handler. The handler SHALL write exception message and stack trace to `crash.log` in the app base directory, show a user-facing error notification including the log path, and prevent abrupt process termination when safe.

#### Scenario: Unhandled exception is caught
- **WHEN** an unhandled exception propagates to the dispatcher
- **THEN** `crash.log` is written to the application base directory
- **THEN** an error notification is shown with the error message and the path to `crash.log`
- **THEN** the application continues running (exception is marked handled)

#### Scenario: Crash log content
- **WHEN** the crash handler fires with a known exception message
- **THEN** `crash.log` contains both the exception message and its stack trace
