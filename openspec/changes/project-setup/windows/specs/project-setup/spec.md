# Windows Spec: project-setup

## ADDED Requirements

### Requirement: WPF application project targets .NET 8
The project SHALL target `net8.0-windows` framework and use the WPF SDK (`Microsoft.NET.Sdk.WindowsDesktop`) with `UseWPF` enabled.

#### Scenario: Project builds successfully
- **WHEN** developer runs `dotnet build` in the `win/` directory
- **THEN** the project compiles without errors targeting `net8.0-windows`

### Requirement: Microsoft.VisualBasic dependency is declared
The project SHALL reference `Microsoft.VisualBasic` to enable `FileSystem.DeleteFile` with recycle-bin support.

#### Scenario: NuGet dependency resolves
- **WHEN** the project is restored with `dotnet restore`
- **THEN** `Microsoft.VisualBasic` is available in the build output

### Requirement: Application entry point initialises the resource dictionary
`App.xaml` SHALL merge at least one `ResourceDictionary` containing shared styles (glass card style, brush definitions, button styles, text styles).

#### Scenario: App launches with styles available
- **WHEN** the application starts
- **THEN** all `StaticResource` references in `MainWindow.xaml` resolve without `XamlParseException`

### Requirement: Assembly metadata declares WPF theme information
`AssemblyInfo.cs` SHALL declare `[assembly: ThemeInfo(ResourceDictionaryLocation.None, ResourceDictionaryLocation.SourceAssembly)]` to inform WPF where to locate theme and generic resource dictionaries.

#### Scenario: WPF theme metadata is present
- **WHEN** the project is built
- **THEN** WPF resolves generic resource-dictionary lookups via the source assembly without runtime errors

### Requirement: Resources directory contains the window icon
A `Resources/` subdirectory SHALL exist under `win/` and contain `icon.png` referenced by `MainWindow.Icon` for the in-window title-bar icon.

#### Scenario: Window icon loads
- **WHEN** `MainWindow` is displayed
- **THEN** the in-window title bar shows the custom icon

### Requirement: Application executable icon is embedded in the binary
The csproj SHALL declare `<ApplicationIcon>Resources\app_icon.ico</ApplicationIcon>` so the compiled `.exe` carries the Windows `.ico` as its embedded application icon, used by the taskbar, Alt+Tab switcher, and Windows Explorer.

#### Scenario: Executable carries application icon
- **WHEN** the project is built
- **THEN** the compiled `MemoriesWizard.exe` displays the custom icon in Windows Explorer and the taskbar

### Requirement: Global unhandled-exception handler writes a crash log and notifies the user
`App.xaml.cs` SHALL subscribe to `Application.DispatcherUnhandledException` in `OnStartup`. The handler SHALL write the exception message and stack trace to `crash.log` in the application base directory, show a `MessageBox` that includes the log path and error message, and mark the exception as handled so the process does not terminate abruptly.

#### Scenario: Unhandled exception is caught
- **WHEN** an unhandled exception propagates to the dispatcher
- **THEN** `crash.log` is written to the application base directory
- **THEN** a `MessageBox` is shown with the error message and the path to `crash.log`
- **THEN** the application continues running (exception is marked handled)

#### Scenario: Crash log content
- **WHEN** the crash handler fires with a known exception message
- **THEN** `crash.log` contains both the exception message and its stack trace
