//
//  ViewModelAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Swinject

final class ViewModelAssembly: Assembly {
  func assemble(container: Container) {
    container.registerMainActor(ColorWizardContentViewModel.self) { _ in
      ColorWizardContentViewModel()
    }.inObjectScope(.transient)
    
    container.registerMainActor(InfiniteCardsViewModel.self) { r in
      InfiniteCardsViewModel(
        colorService: r.resolved(ColorServiceProtocol.self))
    }.inObjectScope(.transient)
    
    container.registerMainActor(LandingViewModel.self) { r in
      LandingViewModel(
        alertService: r.resolved(AlertServiceProtocol.self),
        authenticationService: r.resolved(AuthenticationServiceProtocol.self),
        colorService: r.resolved(ColorServiceProtocol.self))
    }.inObjectScope(.transient)
    
    container.registerMainActor(PulseViewModel.self) { r in
      PulseViewModel(
        authenticationService: r.resolved(AuthenticationServiceProtocol.self),
        colorService: r.resolved(ColorServiceProtocol.self))
    }.inObjectScope(.transient)
    
    container.registerMainActor(SignInViewModel.self) { r in
      SignInViewModel(
        authenticationService: r.resolved(AuthenticationServiceProtocol.self))
    }.inObjectScope(.transient)
  }
}
