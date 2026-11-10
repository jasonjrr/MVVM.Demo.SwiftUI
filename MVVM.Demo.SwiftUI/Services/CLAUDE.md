# Services

Every service is protocol-backed (`*ServiceProtocol`) and registered in `Architecture/Assemblies/ServicesAssembly.swift` as a singleton (`.container`). ViewModels depend on the protocol only, which is what lets tests substitute fakes.

## Service inventory

| Service | Protocol | Purpose |
|---|---|---|
| `AlertService` | `AlertServiceProtocol` | Presents alerts. `present(title:message:dismissButton:)` and `present(title:message:primaryButton:secondaryButton:)` hop to the main actor and set `AlertManager.alert`. |
| `AlertManager` | — | `@Observable @MainActor` holder of the current `AlertPackage`; injected with `.environment(_:)` and rendered by `.navigationAlert(item:)` in the root coordinator view. Also republishes through `alert$`. |
| `AuthenticationService` | `AuthenticationServiceProtocol` | Fake sign in / sign out over a `CurrentValueSubject<User?>`; exposes `user` and `isAuthenticated` publishers. `signOut()` delays 3 s and drives the BusyIndicator. |
| `ColorService` | `ColorServiceProtocol` | `getNextColor()` (lock-guarded counter) and `generateColors(runLoop:)` (1 s timer publisher). `ColorModel` maps to SwiftUI colors via `asColor()` / `asContrastColor()`. |
| BusyIndicator service | `BusyIndicatorServiceProtocol` | From the BusyIndicator package; registered in `assembleThirdParties`. |

`AlertService/AlertService.AlertPackage+View.swift` holds the SwiftUI side (`navigationAlert(item:)`, button roles).

## Service template

```swift
protocol ExampleServiceProtocol: AnyObject, Sendable {
  var items: AnyPublisher<[Item], Never> { get }
  func refresh()
}

final class ExampleService: ExampleServiceProtocol, @unchecked Sendable {
  private let _items: CurrentValueSubject<[Item], Never> = CurrentValueSubject([])
  var items: AnyPublisher<[Item], Never> { self._items.eraseToAnyPublisher() }
  
  func refresh() {
    self._items.send([])
  }
}
```

Register it:

```swift
container.register(ExampleServiceProtocol.self) { _ in
  ExampleService()
}.inObjectScope(.container)
```

## Concurrency rules
- The protocol is `AnyObject, Sendable`. The class is `final`.
- Immutable or lock-guarded state → plain `Sendable`. Combine subjects or other reference state → `@unchecked Sendable`, keeping every mutation behind the subject, a lock or a serial queue.
- Mutable value state uses `OSAllocatedUnfairLock` (see `ColorService.index`).
- Services never touch UI or `@MainActor` state directly; to update UI state hop with `Task { @MainActor in ... }` (see `AlertService`).
- Models that cross actors are `Sendable` (`User`, `ColorModel`, `AlertPackage`); stored closures are `@MainActor @Sendable`.
- Expose publishers, not `@Published`. ViewModels do `.receive(on: RunLoop.main)`.

## Conventions
- Default arguments for protocol methods go in a protocol extension (see `AlertServiceProtocol`, `ColorServiceProtocol`).
- Errors are a nested `enum Errors: Error` on the service (`AuthenticationService.Errors`).
- When a service is added, removed or changes its public API, update this table.
