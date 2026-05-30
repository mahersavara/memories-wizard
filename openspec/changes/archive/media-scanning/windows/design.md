# Windows Design: media-scanning

## Context
`MediaService` is a plain C# class with no WPF dependencies. It uses `System.IO.Directory.EnumerateFiles` for lazy enumeration, avoiding loading all file names into memory at once. The service is injected into `MainWindow` via the `IMediaService` field.

## Goals / Non-Goals
**Goals**: Reliable, testable file discovery with format filtering.  
**Non-Goals**: No file mutation (move/delete), no async operations in v1.

## Decisions

### Interface + concrete class (`IMediaService` / `MediaService`)
Decoupling via interface allows test doubles and makes the scanning contract explicit and portable to macOS.

### Lazy `EnumerateFiles` over `GetFiles`
`Directory.EnumerateFiles` streams entries without allocating the full array, reducing memory use on large directories.

### Dot-prefix hidden file exclusion
Checking `fileName.StartsWith(".")` excludes macOS metadata files (`.DS_Store`), Windows thumbs (`.thumbs`), and other hidden files that would pollute the queue.

## Mermaid: Scan Flow

```mermaid
flowchart TD
    A[GetMediaFiles called] --> B{Path valid?}
    B -->|No| C[Return empty MediaScanResult]
    B -->|Yes| D[EnumerateFiles with SearchOption]
    D --> E{File starts with dot?}
    E -->|Yes| F[Skip file]
    E -->|No| G{Extension in MediaExtensions?}
    G -->|Yes| H[Add to MediaFiles]
    G -->|No| I[Add to UnsupportedFiles]
    H --> J[Return MediaScanResult]
    I --> J
```

## Risks / Trade-offs
- [Risk] Scanning runs on the UI thread → Mitigation: acceptable for v1; future change can wrap in `Task.Run`.

## Migration Plan
N/A — new service.

## Open Questions
*(none)*
