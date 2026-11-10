//
//  ServicesAssembly.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Swinject
import BusyIndicator

final class ServicesAssembly: Assembly {
  func assemble(container: Container) {
    container.registerMainActor(AlertManager.self) { _ in
      AlertManager()
    }.inObjectScope(.container)
    
    container.register(AlertServiceProtocol.self) { r in
      AlertService(alertManager: r.resolved(AlertManager.self))
    }.inObjectScope(.container)
    
    container.register(AuthenticationServiceProtocol.self) { r in
      AuthenticationService(
        busyIndicatorService: r.resolved(BusyIndicatorServiceProtocol.self))
    }.inObjectScope(.container)
    
    container.register(ColorServiceProtocol.self) { _ in
      ColorService()
    }.inObjectScope(.container)
    
    assembleThirdParties(container: container)
  }
  
  private func assembleThirdParties(container: Container) {
    container.register(BusyIndicatorServiceProtocol.self) { _ in
      let config = BusyIndicatorConfiguration()
      config.showBusyIndicatorDelay = 0
      return BusyIndicatorService(configuration: config)
    }.inObjectScope(.container)
  }
}
