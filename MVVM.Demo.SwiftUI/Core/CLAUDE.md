# Core

Reusable helpers with no app logic. Nothing here may depend on `Services/`, `UI/` or `Architecture/` (except `ViewModel` for the extensions that decorate it).

## Inventory

| File | Purpose |
|---|---|
| `HapticFeedbackProvider.swift` | `HapticFeedbackProvider` protocol (adopted by `ViewModel`), `HapticFeedbackStyle`, and `view.haptics.generate(_:)`. UIKit generators are `@MainActor` globals; the call hops to the main actor. |
| `Combine/CancelBag.swift` | `typealias CancelBag = Set<AnyCancellable>` |
| `Combine/Just+Void.swift` | `Just()` for `Void` |
| `Combine/PassthroughSubject+Extensions.swift` | `send()` for `Void` subjects |
| `Combine/Publisher+DefinedScheduler.swift` | `DefinedScheduler` and scheduler-by-name `receive`/`subscribe`/`debounce`/`throttle` |
| `Combine/Publisher+Extensions.swift` | `sink` conveniences, `debug(_:)`, leak-free `withLatestFromUnretained` |
| `Extensions/Container+RegisterMainActor.swift` | `registerMainActor` for Swinject (traps off-main) |
| `Extensions/Resolver+Resolved.swift` | `resolved(_:)`: resolve or `fatalError` with a clear message |
| `Extensions/String+Extensions.swift` | `String.empty`, space helpers |
| `Extensions/UIApplication+EndEditing.swift` | `endEditing()` on `UIApplication`, `View` and `ViewModel` |
| `SwiftUI/CoordinatorNavigationStack.swift` | `CoordinatorNavigationStack` + `@MainActor CoordinatorNavigationPath` (typed stack that keeps its objects in sync with swipe-back) |
| `SwiftUI/Color+SystemColors.swift` | Semantic UIKit colors as `Color` |
| `SwiftUI/EdgeInsets+Extensions.swift` | `EdgeInsets` convenience initializers |

## Rules
- Prefer adding a focused extension file (`Type+Purpose.swift`) over growing an existing one.
- Anything touching UIKit or SwiftUI state is `@MainActor`; anything shared across actors is `Sendable`.
- Update this table when files are added, removed or renamed.
