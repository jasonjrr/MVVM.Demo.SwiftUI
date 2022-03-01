//
//  AlertService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

protocol AlertServiceProtocol: AnyObject {
  func buildAlert(title: String, message: String?, dismissButton: AlertService.AlertPackage.Button?) -> AlertService.AlertPackage
  func buildAlert(title: String, message: String?, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) -> AlertService.AlertPackage
}

extension AlertServiceProtocol {
  func buildAlert(title: String, message: String? = nil, dismissButton: AlertService.AlertPackage.Button? = nil) -> AlertService.AlertPackage {
    self.buildAlert(title: title, message: message, dismissButton: dismissButton)
  }
  
  func buildAlert(title: String, message: String? = nil, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) -> AlertService.AlertPackage {
    self.buildAlert(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
  }
}

class AlertService: AlertServiceProtocol {
  func buildAlert(title: String, message: String? = nil, dismissButton: AlertService.AlertPackage.Button? = nil) -> AlertService.AlertPackage {
    AlertPackage(title: title, message: message, dismissButton: dismissButton)
  }
  
  func buildAlert(title: String, message: String? = nil, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) -> AlertService.AlertPackage {
    AlertPackage(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
  }
}

extension AlertService {
  struct AlertPackage: Identifiable {
    let id: UUID = UUID()
    let title: String
    let message: String?
    let primaryButton: AlertService.AlertPackage.Button
    let secondaryButton: AlertService.AlertPackage.Button?
    
    init(title: String, message: String? = nil, dismissButton: AlertService.AlertPackage.Button? = nil) {
      self.title = title
      self.message = message
      self.primaryButton = dismissButton ?? .cancel()
      self.secondaryButton = nil
    }
    
    init(title: String, message: String? = nil, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) {
      self.title = title
      self.message = message
      self.primaryButton = primaryButton
      self.secondaryButton = secondaryButton
    }
  }
}

extension AlertService.AlertPackage {
  struct Button {
    enum Role {
      case `default`
      case cancel
      case destructive
    }
    
    let role: Role
    let title: String
    let action: (() -> Void)?
    
    static func `default`(_ title: String, action: (() -> Void)? = {}) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .default, title: title, action: action)
    }
    
    static func cancel(_ title: String = "Cancel", action: (() -> Void)? = {}) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .cancel, title: title, action: action)
    }
    
    static func destructive(_ title: String, action: (() -> Void)? = {}) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .destructive, title: title, action: action)
    }
  }
}
