//
//  Resolver+Resolved.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 3/21/24.
//

import Foundation
import Swinject

extension Resolver {
  @inlinable
  func resolved<Service>(_ serviceType: Service.Type) -> Service {
    guard let service = resolve(serviceType) else {
      fatalError("\(serviceType) is required for this app. Please register \(serviceType) in an Assembly.")
    }
    return service
  }
}
