//
//  CoordinatorAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Swinject

class CoordinatorAssembly: Assembly {
  func assemble(container: Container) {
    container.register(AppRootCoordinator.self) { r in
      AppRootCoordinator(resolver: r)
    }.inObjectScope(.container)
    
    container.register(ColorWizardCoordinator.self) { r in
      ColorWizardCoordinator(resolver: r)
    }.inObjectScope(.transient)
  }
}
