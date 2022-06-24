//
//  AlertManager+Environment.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 6/24/22.
//

import SwiftUI

private struct AlertManagerKey: EnvironmentKey {
  static let defaultValue: AlertManager = AlertManager()
}

extension EnvironmentValues {
  public var alertManager: AlertManager {
    get { self[AlertManagerKey.self] }
    set { self[AlertManagerKey.self] = newValue }
  }
}

extension View {
  @inlinable
  func alertManager(_ alertManager: AlertManager) -> some View {
    environment(\.alertManager, alertManager)
  }
}
