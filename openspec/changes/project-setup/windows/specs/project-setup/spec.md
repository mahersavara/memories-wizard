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

### Requirement: Assembly metadata is declared
`AssemblyInfo.cs` SHALL declare the assembly as not CLS-compliant (`CLSCompliant(false)`) to suppress WPF-related warnings.

#### Scenario: Clean build with no CLS warnings
- **WHEN** the project is built
- **THEN** no CLS compliance warnings appear in the build output

### Requirement: Resources directory contains the application icon
A `Resources/` subdirectory SHALL exist under `win/` and contain `icon.png` used as the window icon.

#### Scenario: Window icon loads
- **WHEN** `MainWindow` is displayed
- **THEN** the taskbar and title bar show the custom application icon
