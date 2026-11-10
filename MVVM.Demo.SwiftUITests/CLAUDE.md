# Tests

XCTest unit tests for services and ViewModels. Run with the command in the root `CLAUDE.md`.

## Layout
```
MVVM.Demo.SwiftUITests/
├── Services/                 # AlertService, AuthenticationService, ColorService
├── UI/                       # ViewModels (SignInViewModel)
└── TestExtensions/           # awaitResults(_:) for publishers, Result helpers
```

## Conventions
- A base class per subject builds the subject in `setUp`; each situation is a subclass named `Subject_when_<situation>`; each assertion is a `test_then_<expectation>` method.
- Anything touching a ViewModel, `AlertManager` or other `@MainActor` type: mark the base class `@MainActor` (subclasses inherit it) and use `override func setUp() async throws`.
- Test publishers with `awaitResults(_:)` (collects N values, 5 s timeout) or `for await ... in publisher.values`.
- A Combine closure written in a `@MainActor` test is main-actor-isolated and traps when Combine calls it off-main; write it `@Sendable` (`.compactMap { @Sendable in $0 }`).
- ViewModel delegates are hand-written `@MainActor final class` mocks (see `SignInViewModelDelegateMock`). The ViewModel holds its delegate weakly, so keep the mock in a property.
- Async ViewModel outcomes use `expectation` + `await fulfillment(of:timeout:)`.
- Use real services where they are deterministic (`AuthenticationService`); add a protocol fake when they are not.
