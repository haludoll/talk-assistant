## Architecture
Talk Assistant adopts lightweight Domain-Driven Design to keep feature boundaries explicit across Swift packages.

### Bounded Contexts
| Context | Responsibility |
| --- | --- |
| Conversation | Phrase authoring, categorization, and playback triggers. |
| SpeechSynthesizer | Speech synthesis pipeline, voice configuration, and sample playback. |
| Settings | Advanced preferences plus legal and policy surfaces. |
| LocalStorage | Shared SwiftData models and persistence primitives. |

### Package-Level Structure
Each context is split into targets for Presentation, ViewModel, Repository, Entity, and Dependency layers. The pattern pairs SwiftUI views with MVVM state management while keeping persistence and integration concerns isolated behind repository interfaces.

```
MyContext/
├── Presentation
├── ViewModel
├── Repository
├── Entity
└── Dependency
```

- Presentation renders SwiftUI views and delegates logic to the view-model layer.
- ViewModel exposes state and actions, requesting services through dependency interfaces.
- Repository provides live data sources (SwiftData, AVFoundation, network, etc.).
- Entity defines shared domain models.
- Dependency registers live implementations and exposes them via `@Dependency`.

### Dependency Flow
- The app target depends only on the Root package, which composes feature presentation modules.
- Cross-context usage goes through dependency targets (e.g., Conversation imports `SpeechSynthesizerDependency`).
- `swift-dependencies` supplies concrete instances at the feature boundary, keeping tests free to provide overrides.
