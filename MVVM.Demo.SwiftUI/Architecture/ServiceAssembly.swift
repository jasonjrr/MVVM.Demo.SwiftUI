//
//  ServiceAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Swinject

class ServiceAssembly: Assembly {
  func assemble(container: Container) {
    container.register(AlertManager.self) { r in
      AlertManager()
    }.inObjectScope(.container)
    
    container.register(AlertServiceProtocol.self) { r in
      AlertService(alertManager: r.resolve(AlertManager.self)!)
    }.inObjectScope(.container)
    
    container.register(AuthenticationServiceProtocol.self) { r in
      AuthenticationService()
    }.inObjectScope(.container)
    
    container.register(ColorServiceProtocol.self) { r in
      ColorService()
    }.inObjectScope(.container)
  }
}
