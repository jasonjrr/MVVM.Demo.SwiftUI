//
//  ViewModelAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Swinject

class ViewModelAssembly: Assembly {
  func assemble(container: Container) {
    container.register(ColorWizardContentViewModel.self) { r in
      ColorWizardContentViewModel()
    }.inObjectScope(.transient)
    
    container.register(LandingViewModel.self) { r in
      LandingViewModel(
        alertService: r.resolve(AlertServiceProtocol.self)!,
        authenticationService: r.resolve(AuthenticationServiceProtocol.self)!,
        colorService: r.resolve(ColorServiceProtocol.self)!)
    }.inObjectScope(.transient)
    
    container.register(PulseViewModel.self) { r in
      PulseViewModel(
        authenticationService: r.resolve(AuthenticationServiceProtocol.self)!,
        colorService: r.resolve(ColorServiceProtocol.self)!)
    }.inObjectScope(.transient)
    
    container.register(SignInViewModel.self) { r in
      SignInViewModel(
        authenticationService: r.resolve(AuthenticationServiceProtocol.self)!)
    }.inObjectScope(.transient)
  }
}
