//
//  AlertService.AlertPackage+View.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 2/28/22.
//

import SwiftUI

// MARK: ButtonRole

extension AlertService.AlertPackage.Button.Role {
  var buttonRole: ButtonRole? {
    switch self {
    case .default: return nil
    case .destructive: return .destructive
    case .cancel: return .cancel
    }
  }
}

// MARK: View

extension View {
  /// Present an iOS system-style alert from SwiftUI Coordinator pattern.
  func navigationAlert(item: Binding<AlertService.AlertPackage?>) -> some View {
    let isActive = Binding(
      get: { item.wrappedValue != nil },
      set: { value in
        if !value {
          item.wrappedValue = nil
        }
      }
    )
    return self.alert(
      item.wrappedValue?.title ?? .empty,
      isPresented: isActive,
      actions: {
        if let secondary = item.wrappedValue?.secondaryButton {
          Button(secondary.title, role: secondary.role.buttonRole, action: { secondary.action?() })
        }
        if let primary = item.wrappedValue?.primaryButton {
          Button(primary.title, role: primary.role.buttonRole, action: { primary.action?() })
        }
      },
      message: {
        if let message = item.wrappedValue?.message {
          Text(message)
        }
      })
  }
}
