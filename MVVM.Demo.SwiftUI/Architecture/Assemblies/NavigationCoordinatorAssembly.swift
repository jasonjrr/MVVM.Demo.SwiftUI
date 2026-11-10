//
//  NavigationCoordinatorAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Swinject

final class NavigationCoordinatorAssembly: Assembly {
  func assemble(container: Container) {
    container.registerMainActor(AppNavigationCoordinatorViewModel.self) { r in
      AppNavigationCoordinatorViewModel(resolver: r)
    }.inObjectScope(.container)
    
    container.registerMainActor(ColorWizardCoordinatorViewModel.self) { r in
      ColorWizardCoordinatorViewModel(resolver: r)
    }.inObjectScope(.transient)
  }
}
