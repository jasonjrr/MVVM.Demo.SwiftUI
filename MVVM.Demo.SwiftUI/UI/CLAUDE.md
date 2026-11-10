# UI

One folder per feature, holding the `View` and `ViewModel` together. Coordinators live in `Architecture/NavigationCoordinators/`, not here.

## Features

| Folder | Files | Presented as |
|---|---|---|
| `Landing/` | `LandingView`, `LandingViewModel` | root of the app stack |
| `SignIn/` | `SignInView`, `SignInViewModel` | overlay from the root coordinator |
| `Pulse/` | `PulseView`, `PulseViewModel` (+ `ColorItem` rows) | pushed |
| `InfiniteCards/` | `InfiniteCardsView`, `InfiniteCardsViewModel` (+ `CardViewModel`) | full-screen cover |
| `ColorWizard/` | `Configuration/` (model + `ColorWizardConfigurationViewModel`), `Content/` (`ColorWizardContentView`, `ColorWizardContentViewModel`) | pushed by `ColorWizardCoordinator` |
| `Views/` | `CardView`, `VisualEffectView` | shared views |
| `Styles/` | `ButtonStyles/BrightBorderedButtonStyle`, `TextStyles/TextStyle` + `ButtonTextStyle` | shared styles |

## ViewModel template

```swift
@Observable @MainActor
final class ExampleViewModel: ViewModel {
  @ObservationIgnored private let colorService: ColorServiceProtocol
  
  @ObservationIgnored private weak var delegate: Delegate?
  
  private(set) var color: ColorModel?
  var query: String = .empty
  
  var canSubmit: Bool { !self.query.isEmpty }
  
  @ObservationIgnored private var cancelBag: CancelBag = CancelBag()
  
  init(colorService: ColorServiceProtocol) {
    self.colorService = colorService
  }
  
  @discardableResult
  func setup(delegate: Delegate) -> Self {
    self.delegate = delegate
    bind()
    return self
  }
  
  private func bind() {
    self.cancelBag = CancelBag()
    
    self.colorService.generateColors()
      .receive(on: RunLoop.main)
      .sink { [weak self] color in
        self?.color = color
      }
      .store(in: &self.cancelBag)
  }
  
  func submit() {
    self.delegate?.exampleViewModelDidSubmit(self)
  }
}

extension ExampleViewModel {
  @MainActor protocol Delegate: AnyObject {
    func exampleViewModelDidSubmit(_ source: ExampleViewModel)
  }
}
```

Rules:
- Dependencies are `@ObservationIgnored private let` protocols injected through `init`; `weak var delegate` is also `@ObservationIgnored`.
- State the View reads is `private(set) var` (or `var` when the View binds to it). Derived state is a computed property (`canSubmit`), not a second stored value.
- User actions are plain methods (`submit()`), not subjects.
- Subscribe in `setup`/`bind()`, reset `cancelBag` there, and always `.receive(on: RunLoop.main)` before touching state.
- No `import SwiftUI` unless the type needs `Color`/`Animation`; never UIKit views.

## View template

```swift
struct ExampleView: View {
  @Bindable private var viewModel: ExampleViewModel
  
  init(viewModel: ExampleViewModel) {
    self.viewModel = viewModel
  }
  
  var body: some View {
    VStack {
      TextField("Query", text: self.$viewModel.query)
      Button(action: self.viewModel.submit) {
        Text("Submit")
      }
      .disabled(!self.viewModel.canSubmit)
    }
  }
}

#Preview {
  ExampleView(viewModel: AppAssembler().resolver.resolved(ExampleViewModel.self))
}
```

Rules:
- `@Bindable private var viewModel` with an explicit `init`; read and bind with `self.viewModel` / `self.$viewModel`.
- Only transient presentation state (animations, focus) uses `@State` / `@FocusState`.
- Scaled dimensions use `@ScaledMetric`.
- Split large bodies into private `func name() -> some View` helpers (see `LandingView`).
- Use the shared styles: `.buttonStyle(.brightBorderedButton)`, `.textStyle(.button)`, `CardView`.
- Row ViewModels used in `ForEach` are their own `@Observable @MainActor final class` with a nested `View` that takes it (see `PulseView.PulseCircle`).

## Adding a feature

Follow the checklist in the root `CLAUDE.md`. Register the ViewModel in `Architecture/Assemblies/ViewModelAssembly.swift` and wire navigation in the owning coordinator.
