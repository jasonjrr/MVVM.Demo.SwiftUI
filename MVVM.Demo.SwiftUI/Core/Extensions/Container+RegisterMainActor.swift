//
//  Container+RegisterMainActor.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/9/26.
//

import Foundation
import Swinject

private struct UncheckedSendableBox<Value>: @unchecked Sendable {
  let value: Value
}

extension Container {
  /// Registers a `@MainActor` factory; resolving off the main thread traps because Swinject holds its lock during the factory.
  @discardableResult
  func registerMainActor<Service>(
    _ serviceType: Service.Type,
    name: String? = nil,
    factory: @escaping @MainActor (Resolver) -> Service
  ) -> ServiceEntry<Service> {
    let mainActorFactory = { (resolver: Resolver) -> Service in
      nonisolated(unsafe) let resolver = resolver
      return MainActor.assumeIsolated {
        UncheckedSendableBox(value: factory(resolver))
      }.value
    }
    return _register(serviceType, factory: mainActorFactory, name: name)
  }
}
