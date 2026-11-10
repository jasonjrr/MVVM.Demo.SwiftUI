# Architecture

## Navigation Coordinator Pattern

Each flow has a coordinator pair: `*CoordinatorViewModel` + `*CoordinatorView`, in `NavigationCoordinators/<Name>Coordinator/`.

```
AppNavigationCoordinatorViewModel     root coordinator (.container); owns the Landing screen
├── LandingViewModel                  root of the stack
├── PulseViewModel                    pushed onto `path`
├── InfiniteCardsViewModel            full-screen cover (optional property)
├── SignInViewModel                   overlay (optional property)
└── ColorWizardCoordinatorViewModel   child coordinator in a full-screen cover; owns its own `path`
    └── ColorWizardContentViewModel   one per wizard page, pushed onto the child's `path`
```

| Coordinator | Files |
|---|---|
| `AppNavigationCoordinator` | `AppNavigationCoordinatorViewModel.swift`, `AppNavigationCoordinatorView.swift` |
| `ColorWizardCoordinator` | `ColorWizardCoordinatorViewModel.swift`, `ColorWizardCoordinatorView.swift` |

### Coordinator responsibilities
- Holds the `Resolver` (`@ObservationIgnored private let resolver`). It is the only object that does.
- Creates child ViewModels with `resolver.resolved(X.self).setup(delegate: self)`.
- Adopts each child's `Delegate` in its own extension and navigates in response.
- Stack navigation: a `let path: CoordinatorNavigationPath`; call `append`, `removeLast`, `removeLast(through:)`, `removeAll`.
- Modals/overlays: an optional ViewModel property; set it to `nil` to dismiss.
- A parent never reaches into a child coordinator's path; the child reports through its own `Delegate` (`colorWizardCoordinatorViewModelDidComplete`).

### Coordinator template

```swift
@Observable @MainActor
final class ExampleCoordinatorViewModel: ViewModel {
  @ObservationIgnored private let resolver: Resolver
  
  @ObservationIgnored private weak var delegate: Delegate?
  
  let path: CoordinatorNavigationPath = CoordinatorNavigationPath()
  let rootViewModel: ExampleViewModel
  
  var detailsViewModel: DetailsViewModel?
  
  init(resolver: Resolver) {
    self.resolver = resolver
    self.rootViewModel = resolver.resolved(ExampleViewModel.self)
    self.rootViewModel.setup(delegate: self)
  }
  
  @discardableResult
  func setup(delegate: Delegate) -> Self {
    self.delegate = delegate
    return self
  }
}

extension ExampleCoordinatorViewModel {
  @MainActor protocol Delegate: AnyObject {
    func exampleCoordinatorViewModelDidComplete(_ source: ExampleCoordinatorViewModel)
  }
}

// MARK: ExampleViewModel.Delegate
extension ExampleCoordinatorViewModel: ExampleViewModel.Delegate {
  func exampleViewModelDidTapDetails(_ source: ExampleViewModel) {
    self.detailsViewModel = self.resolver.resolved(DetailsViewModel.self).setup(delegate: self)
  }
}
```

The matching view binds directly to the coordinator; there are no `@State` mirrors:

```swift
struct ExampleCoordinatorView: View {
  @Bindable private var coordinator: ExampleCoordinatorViewModel
  
  init(coordinator: ExampleCoordinatorViewModel) {
    self.coordinator = coordinator
  }
  
  var body: some View {
    CoordinatorNavigationStack(path: self.coordinator.path) {
      ExampleView(viewModel: self.coordinator.rootViewModel)
        .navigationDestination(for: PushedViewModel.self) { PushedView(viewModel: $0) }
    }
    .fullScreenCover(item: self.$coordinator.detailsViewModel) { DetailsView(viewModel: $0) }
  }
}
```

### Delegate pattern
- Every ViewModel declares `extension X { @MainActor protocol Delegate: AnyObject { ... } }` and holds it `weak`.
- Method names follow `<viewModel>DidTap<Thing>(_ source: <ViewModel>)`; queries use `<viewModel>(_ source:, canX...)`.
- ViewModels never navigate; they report the intent and the coordinator acts.

## Dependency Injection (Swinject)

Located in `Assemblies/`:

| File | Registers |
|---|---|
| `AppAssembler.swift` | Builds the `Assembler` from the three assemblies below; exposes `resolver` |
| `ServicesAssembly.swift` | Services (`.container`), `AlertManager` and the BusyIndicator service |
| `ViewModelAssembly.swift` | Every ViewModel (`.transient`) |
| `NavigationCoordinatorAssembly.swift` | Coordinators: the root (`.container`), child coordinators (`.transient`) |

- **`registerMainActor`** (`Core/Extensions/Container+RegisterMainActor.swift`) registers a `@MainActor` factory via `MainActor.assumeIsolated`. Resolving such a type off the main thread traps instead of hopping, because Swinject holds its container lock during the factory and a synchronous hop could deadlock. Use it for every ViewModel, coordinator and `@MainActor` service.
- Plain `container.register` is for nonisolated services only.
- Register concrete types as their protocol (`container.register(AlertServiceProtocol.self)`), and list dependencies in alphabetical order in the factory call.
- `AppAssembler` is created once, as a stored property of `MVVM_Demo_SwiftUIApp`. Previews use `AppAssembler().resolver`.

## ViewModel base type

`ViewModel.swift` defines `protocol ViewModel: AnyObject, Identifiable, Hashable, HapticFeedbackProvider` with identity-based `==`/`hash`, which is what lets ViewModels be `NavigationPath` elements, `ForEach` items and `fullScreenCover(item:)` values. `endEditing()` is available on every ViewModel (`@MainActor`).

## App entry

`MVVM_Demo_SwiftUIApp` resolves the root coordinator and injects two things for the whole tree: `AlertManager` via `.environment(_:)` (read with `@Environment(AlertManager.self)`) and the BusyIndicator via `.busyIndicator(_:)`. The root coordinator view presents alerts with `.navigationAlert(item:)`.
