# MVVM.Demo.SwiftUI Architecture Guide

## Project Overview
A small SwiftUI app that demonstrates MVVM + Navigation Coordinators + Dependency Injection with Swift 6 strict concurrency. It is a reference for building real apps: copy its structure and keep to its patterns when adding features.

Demo screens: Landing (root), Sign In (overlay), Pulse (pushed), Infinite Cards (full-screen cover), Color Wizard (child coordinator in a full-screen cover).

## Tech Stack
- **Language**: Swift 6 (language mode 6, complete strict concurrency)
- **UI Framework**: SwiftUI with the Observation framework (`@Observable`, `@Bindable`)
- **Minimum Deployment**: iOS 17.0
- **Toolchain**: Xcode 27 (project saved in the Xcode 27 JSON format)
- **Architecture Pattern**: MVVM + Navigation Coordinator Pattern
- **Dependency Injection**: Swinject
- **Reactive**: Combine + CombineExt (services publish, ViewModels subscribe)
- **Busy state**: BusyIndicator

## Getting Started

1. Open `MVVM.Demo.SwiftUI.xcodeproj` in Xcode 27 or later. Swift packages resolve over HTTPS; no SSH key is needed.
2. Select the `MVVM.Demo.SwiftUI` scheme and an iPhone simulator, then Run. The simulator needs no signing. To run on a device, set your own team in the target's Signing settings.

Command line (list simulators with `xcrun simctl list devices available`):

```bash
xcodebuild -project MVVM.Demo.SwiftUI.xcodeproj -scheme MVVM.Demo.SwiftUI -destination 'generic/platform=iOS Simulator' build
```

```bash
xcodebuild -project MVVM.Demo.SwiftUI.xcodeproj -scheme MVVM.Demo.SwiftUI -destination 'platform=iOS Simulator,name=<simulator name>' -only-testing:MVVM.Demo.SwiftUITests test
```

The build must stay free of errors **and warnings**. Fix concurrency diagnostics at the source; never lower `SWIFT_VERSION` or relax strict concurrency to make a build pass.

## The Xcode 27 JSON Project

`MVVM.Demo.SwiftUI.xcodeproj/project.xcproj` is a JSON project file. There is no `project.pbxproj`.

- The `MVVM.Demo.SwiftUI`, `MVVM.Demo.SwiftUITests` and `MVVM.Demo.SwiftUIUITests` entries are **folders**. Any `.swift` file or asset created inside them joins the right target automatically. Do not add files to the project by hand.
- A non-source file inside a synced folder (for example a `CLAUDE.md`) must be listed in that folder's `membership-exceptions` → `exclusions` so it is not copied into the bundle. Existing ones: `Architecture/CLAUDE.md`, `Core/CLAUDE.md`, `Services/CLAUDE.md`, `UI/CLAUDE.md`, and the tests' `CLAUDE.md`.
- Edit `project.xcproj` only for build settings, targets and package dependencies. Keep packages pinned to exact versions.
- To convert another project: `xcodebuild -convert-project "Xcode Project" -project <name>.xcodeproj`.

## Project Structure

```
MVVM.Demo.SwiftUI/
├── MVVM.Demo.SwiftUI/                  # App target (synced folder)
│   ├── MVVM_Demo_SwiftUIApp.swift      # @main; owns AppAssembler, injects AlertManager + BusyIndicator
│   ├── Architecture/
│   │   ├── ViewModel.swift             # ViewModel protocol
│   │   ├── Assemblies/                 # Swinject assemblies
│   │   └── NavigationCoordinators/     # *CoordinatorViewModel + *CoordinatorView pairs
│   ├── Core/                           # Combine / Foundation / SwiftUI helpers, no app logic
│   ├── Services/                       # Protocol-backed services
│   └── UI/                             # Features: View + ViewModel side by side
├── MVVM.Demo.SwiftUITests/             # Unit tests (XCTest)
└── MVVM.Demo.SwiftUIUITests/           # UI tests
```

## Architecture Patterns

### 1. MVVM
- **View**: a SwiftUI `struct` that renders a ViewModel. No business logic, no meaningful `@State` (animation-only state such as `showCard` is fine). Holds `@Bindable private var viewModel`.
- **ViewModel**: `@Observable @MainActor final class X: ViewModel`. Owns presentation state and logic, depends on services through protocols, never imports or knows its View.
- **Service/Model**: anything that provides data or state. Knows nothing about Views or ViewModels.

### 2. Navigation Coordinator Pattern
- Each flow has a `*CoordinatorViewModel` + `*CoordinatorView` pair in `Architecture/NavigationCoordinators/<Name>Coordinator/`.
- The coordinator is the **only** type that holds the Swinject `Resolver`. It resolves child ViewModels, adopts their `Delegate` protocols and decides where each action navigates.
- Stack pushes go through a `CoordinatorNavigationPath`; modals are optional ViewModel properties (set to `nil` to dismiss).

### 3. Dependency Injection (Swinject)
- Three assemblies registered by `AppAssembler`: `NavigationCoordinatorAssembly`, `ServicesAssembly`, `ViewModelAssembly`.
- Services use `.inObjectScope(.container)`; ViewModels and child coordinators use `.inObjectScope(.transient)`; the root coordinator is `.container`.
- ViewModels and coordinators register with `registerMainActor` (see `Architecture/CLAUDE.md`). Resolve with `resolver.resolved(X.self)` (a `fatalError` with a clear message if unregistered), never `resolve(...)!`.

### 4. Reactive Flow
Services expose Combine publishers. A ViewModel subscribes in `setup(delegate:)` / `bind()`, hops to the main run loop, and writes the result into an `@Observable` property that the View reads. Views do not subscribe to publishers.

## Swift 6 Concurrency Rules

| Type | Rule |
|---|---|
| ViewModel / coordinator | `@Observable @MainActor final class`. Nested `@MainActor protocol Delegate: AnyObject`. |
| Service protocol | `protocol XServiceProtocol: AnyObject, Sendable` |
| Service with no mutable state | `final class`, and `Sendable` is checked by the compiler |
| Service with mutable state | Guard it with `OSAllocatedUnfairLock` (see `ColorService`) |
| Service built on Combine subjects | `final class ...: @unchecked Sendable` (see `AuthenticationService`) |
| Combine `sink` that touches a ViewModel | `.receive(on: RunLoop.main)` first, then `[weak self]` |
| Value types crossing actors | Mark `Sendable` (`User`, `ColorModel`, `AlertPackage`) |
| Closures stored for later (alert buttons) | `@MainActor @Sendable` |
| Globals | No mutable or non-`Sendable` globals; put UIKit objects behind `@MainActor` |

A `.sink`/`.compactMap` closure written inside a `@MainActor` context is inferred main-actor-isolated and traps if Combine calls it off the main thread. In tests, mark such closures `@Sendable`.

## Development Guidelines

### Adding a New Feature (checklist)
1. Create `UI/<Feature>/<Feature>ViewModel.swift` and `<Feature>View.swift` (templates in `UI/CLAUDE.md`).
2. Register the ViewModel in `ViewModelAssembly` (`registerMainActor`, `.transient`).
3. If it needs a new service, add the protocol + implementation in `Services/` and register it in `ServicesAssembly` (`.container`).
4. In the coordinator that owns the navigation, resolve the ViewModel, call `setup(delegate:)`, and adopt `<Feature>ViewModel.Delegate` in an extension.
5. Present it from the coordinator's View: `path.append(...)` + `.navigationDestination(for:)` for pushes, or an optional property + `.fullScreenCover(item: self.$coordinator.x)` / `.sheet` for modals.
6. If the feature has its own multi-step flow, give it a child coordinator (see `ColorWizardCoordinator`).
7. Add unit tests for new services and ViewModels.
8. Build with zero warnings, run the tests, run the app in a simulator.
9. Update the relevant `CLAUDE.md` files.

### Code Style
- Two-space indentation (do not reformat existing files).
- Always write `self.` for member access.
- Use `String.empty`, never an empty string literal.
- Every file starts with the standard `//  File.swift / //  MVVM.Demo.SwiftUI / //  Created by ...` header.
- Comments: none by default. When one is needed, a single concise line that says *why*; reserve `///` for API docs. Prefer self-documenting names.
- Group protocol conformances with `// MARK: Type.Delegate` extensions.
- Previews use `#Preview` and resolve ViewModels from `AppAssembler().resolver`.

### Do Not
- Put business logic in a View, or give a ViewModel a reference to a View.
- Resolve from the container anywhere except coordinators and assembly closures.
- Navigate from a ViewModel; call its delegate and let the coordinator navigate.
- Reintroduce `ObservableObject`, `@Published`, `@StateObject` or `PreviewProvider`.
- Hand-edit or recreate a `.pbxproj`.

## Testing
- Unit tests in `MVVM.Demo.SwiftUITests/`, mirroring the app folders. See `MVVM.Demo.SwiftUITests/CLAUDE.md`.
- Test names read as `Subject_when_<situation>` classes with `test_then_<expectation>` methods.

## CLAUDE.md Maintenance

**Keep these files current.** When you add, remove or rename files, types or patterns in a directory that has a `CLAUDE.md`, update it before finishing the task: file inventories, service lists, assembly registrations, and any rule you changed. A new `CLAUDE.md` inside a synced folder must also be added to that folder's `membership-exceptions` in `project.xcproj`.

- `CLAUDE.md` — this file
- `MVVM.Demo.SwiftUI/Architecture/CLAUDE.md` — coordinators, assemblies, DI details
- `MVVM.Demo.SwiftUI/UI/CLAUDE.md` — feature folders, View/ViewModel templates, styles
- `MVVM.Demo.SwiftUI/Services/CLAUDE.md` — service template and inventory
- `MVVM.Demo.SwiftUI/Core/CLAUDE.md` — shared helpers inventory
- `MVVM.Demo.SwiftUITests/CLAUDE.md` — test conventions

## Related
- `README.md` — conceptual overview of View / ViewModel / Model / Coordinator / DI
