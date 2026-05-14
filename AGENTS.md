# Instructions for AI Agent working on this project

AI Agents must read and follow the instruction below

## Project Context

Memories Wizard is a tinder-like application to help the user to select best image base on like or dislike navigation (left or right)

### Technical Stack

This project support cross-Platforms:
  - Windows: C# / WPF (XAML), .NET, project at win/MemoriesWizard.csproj
  - macOS: Swift / SwiftUI, project at macOS/MemoriesWizard/

Each feature ships on both platforms independently

## Git Protocol

Have the following prefix for commit messages

- `feat(platform):` When implement new feature
- `fix(platform):` When implement a bug fix
- `spec:` When add or modify openspec changes
- `agent:` When create or modify the agent skills or agent instructions file
- `project:` Anything related to project setup. For example: `.gitignore` or development tool in `mise.toml`
- `docs:` When adding new documentation in the `docs` folder
