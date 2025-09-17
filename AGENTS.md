# Repository Guidelines

## Project Structure & Module Organization
- `App/` hosts the Xcode workspace, iOS target, assets, and Firebase plist; open `talk-assistant.xcworkspace` for hands-on work.
- `Root/` composes the feature packages; sibling directories (`Conversation/`, `Settings/`, `SpeechSynthesizer/`, `LocalStorage/`, `ViewExtensions/`) are SwiftPM modules with `Sources/` and `Tests/`.
- `Conversation/` and `Settings/` expose `*Presentation`, `*ViewModel`, and `*Dependency` libraries; keep shared modifiers in `ViewExtensions/` and persistence in `LocalStorage/`.
- Use `docs/` for reference notes, `app-store-screenshots/` for marketing assets, and `ci_scripts/ci_post_clone.sh` when adjusting pipelines.

## Build, Test, and Development Commands
- `open App/talk-assistant.xcworkspace` – launches the workspace with the configured schemes and test plan.
- `xcodebuild -workspace App/talk-assistant.xcworkspace -scheme talk-assistant -destination "platform=iOS Simulator,name=iPhone 15" build` – CI-safe build of the production target.
- `xcodebuild test -workspace App/talk-assistant.xcworkspace -scheme talk-assistant -testPlan talk-assistant` – runs the shared `talk-assistant.xctestplan` across targets.
- `swift test --package-path Conversation` (repeat for `Settings/` or `Root/`) – executes package-level XCTest suites headlessly.

## Coding Style & Naming Conventions
Favor Swift 6 defaults: four-space indentation, optional trailing commas, and SwiftUI-first composition. Types use PascalCase (`PhraseCategoryEditView`), properties and functions use camelCase, and module names mirror package products (e.g., `ConversationEntity`). Prefer dependency injection through `swift-dependencies`, localize strings with `String(localized:bundle:)`, and keep previews in `#Preview` blocks grouped by feature.

## Testing Guidelines
All tests use XCTest and live beside their modules in `Tests/*`. Name classes `<Feature>Tests` and methods `test_<behavior>` to match suites like `PhraseSpeakViewModelTests`. Cover state changes and async flows with expectations, and run the workspace test plan before pushing; package-only work can rely on targeted `swift test` runs. Focus new coverage on public APIs instead of broad snapshots.

## Commit & Pull Request Guidelines
Follow the existing sentence-case, imperative commit style (`Fix to display term of use...`) and include the related issue number (`#92`) when applicable. Squash noisy WIP histories locally. PRs should summarize the change, call out affected modules, link issues, and attach simulator screenshots or screen recordings for UI-facing updates. Mention any localization, Firebase, or configuration changes explicitly so reviewers can validate downstream tooling. Respond to review comments and repository Q&A in Japanese to keep feedback consistent for the team.

## Configuration & Environment Notes
Google services and Crashlytics require the bundled `GoogleService-Info.plist`; do not commit environment-specific secrets. Verify privacy updates in `PrivacyInfo.xcprivacy` when integrating new SDKs. Keep bundle identifiers and entitlements aligned with the workspace targets before preparing App Store builds.
