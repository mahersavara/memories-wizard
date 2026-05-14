# Windows Tasks: project-setup

## 1. Project File

- [x] 1.1 Create `win/MemoriesWizard.csproj` targeting `net8.0-windows` with `UseWPF=true`
- [x] 1.2 Add `Microsoft.VisualBasic` reference to `MemoriesWizard.csproj`

## 2. Application Entry Point

- [x] 2.1 Create `win/App.xaml` with merged `ResourceDictionary` for global styles
- [x] 2.2 Create `win/App.xaml.cs` with `Application` subclass
- [x] 2.3 Create `win/AssemblyInfo.cs` with `CLSCompliant(false)` attribute

## 3. Resources

- [x] 3.1 Create `win/Resources/` directory
- [x] 3.2 Add `icon.png` to `win/Resources/` and set as `Resource` in csproj

## 4. Validation

- [x] 4.1 Run `dotnet build win/MemoriesWizard.csproj` and confirm zero errors
- [x] 4.2 Launch app and verify window icon and global styles are applied
