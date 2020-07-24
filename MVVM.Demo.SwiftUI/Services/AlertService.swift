//
//  AlertService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

protocol AlertServiceProtocol: AnyObject {
  func buildAlert(title: String, message: String?, dismissButton: AlertService.Alert.Button?) -> AlertService.Alert
  func buildAlert(title: String, message: String?, primaryButton: AlertService.Alert.Button, secondaryButton: AlertService.Alert.Button) -> AlertService.Alert
}

extension AlertServiceProtocol {
  func buildAlert(title: String, message: String? = nil, dismissButton: AlertService.Alert.Button? = nil) -> AlertService.Alert {
    self.buildAlert(title: title, message: message, dismissButton: dismissButton)
  }
  
  func buildAlert(title: String, message: String? = nil, primaryButton: AlertService.Alert.Button, secondaryButton: AlertService.Alert.Button) -> AlertService.Alert {
    self.buildAlert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
  }
}

class AlertService: AlertServiceProtocol {
  func buildAlert(title: String, message: String? = nil, dismissButton: AlertService.Alert.Button? = nil) -> AlertService.Alert {
    Alert(title: title, message: message, dismissButton: dismissButton)
  }
  
  func buildAlert(title: String, message: String? = nil, primaryButton: AlertService.Alert.Button, secondaryButton: AlertService.Alert.Button) -> AlertService.Alert {
    Alert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
  }
}

extension AlertService {
  struct Alert: Identifiable {
    let id: UUID = UUID()
    let title: String
    let message: String?
    let primaryButton: AlertService.Alert.Button
    let secondaryButton: AlertService.Alert.Button?
    
    init(title: String, message: String? = nil, dismissButton: AlertService.Alert.Button? = nil) {
      self.title = title
      self.message = message
      self.primaryButton = dismissButton ?? .cancel()
      self.secondaryButton = nil
    }
    
    init(title: String, message: String? = nil, primaryButton: AlertService.Alert.Button, secondaryButton: AlertService.Alert.Button) {
      self.title = title
      self.message = message
      self.primaryButton = primaryButton
      self.secondaryButton = secondaryButton
    }
  }
}

extension AlertService.Alert {
  struct Button {
    enum Role {
      case `default`
      case cancel
      case destructive
      
      var buttonRole: ButtonRole? {
        switch self {
        case .default: return nil
        case .destructive: return .destructive
        case .cancel: return .cancel
        }
      }
    }
    
    let role: Role
    let title: String
    let action: (() -> Void)?
    
    static func `default`(_ title: String, action: (() -> Void)? = {}) -> AlertService.Alert.Button {
      AlertService.Alert.Button(role: .default, title: title, action: action)
    }
    
    static func cancel(_ title: String = "Cancel", action: (() -> Void)? = {}) -> AlertService.Alert.Button {
      AlertService.Alert.Button(role: .cancel, title: title, action: action)
    }
    
    static func destructive(_ title: String, action: (() -> Void)? = {}) -> AlertService.Alert.Button {
      AlertService.Alert.Button(role: .destructive, title: title, action: action)
    }
  }
}

import SwiftUI
extension AlertService.Alert {
  func view() -> SwiftUI.Alert {
    if let secondaryButton = self.secondaryButton {
      return SwiftUI.Alert(
        title: Text(self.title),
        message: self.message == nil ? nil : Text(self.message!),
        primaryButton: button(self.primaryButton),
        secondaryButton: button(secondaryButton))
    } else {
      return SwiftUI.Alert(
        title: Text(self.title),
        message: self.message == nil ? nil : Text(self.message!),
        dismissButton: button(self.primaryButton))
    }
  }
  
  private func button(_ button: AlertService.Alert.Button) -> SwiftUI.Alert.Button {
    switch button.role {
    case .default:
      return .default(Text(button.title), action: button.action)
    case .cancel:
      return .cancel(Text(button.title), action: button.action)
    case .destructive:
      return .destructive(Text(button.title), action: button.action)
    }
  }
}

extension View {
  /// Present an iOS system-style alert from SwiftUI Coordinator pattern.
  func navigationAlert(item: Binding<AlertService.Alert?>) -> some View {
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
