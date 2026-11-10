//
//  AlertService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

// MARK: AlertManager
@Observable @MainActor
final class AlertManager: Equatable {
  var alert: AlertService.AlertPackage? {
    didSet { self.alert$.send(self.alert) }
  }
  let alert$: CurrentValueSubject<AlertService.AlertPackage?, Never> = CurrentValueSubject(nil)
  
  nonisolated static func ==(lhs: AlertManager, rhs: AlertManager) -> Bool {
    lhs === rhs
  }
}

// MARK: AlertServiceProtocol
protocol AlertServiceProtocol: AnyObject, Sendable {
  func present(title: String, message: String?, dismissButton: AlertService.AlertPackage.Button?)
  func present(title: String, message: String?, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button)
}

extension AlertServiceProtocol {
  func present(title: String, message: String? = nil, dismissButton: AlertService.AlertPackage.Button? = nil) {
    present(title: title, message: message, dismissButton: dismissButton)
  }
  
  func present(title: String, message: String? = nil, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) {
    present(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
  }
}

final class AlertService: AlertServiceProtocol {
  private let manager: AlertManager
  
  init(alertManager: AlertManager) {
    self.manager = alertManager
  }
  
  func present(title: String, message: String?, dismissButton: AlertService.AlertPackage.Button?) {
    let alert = AlertPackage(title: title, message: message, dismissButton: dismissButton)
    Task { @MainActor in
      self.manager.alert = alert
    }
  }
  
  func present(title: String, message: String?, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) {
    let alert = AlertPackage(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
    Task { @MainActor in
      self.manager.alert = alert
    }
  }
}

extension AlertService {
  struct AlertPackage: Identifiable, Equatable, Sendable {
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
    
    static func ==(lhs: AlertPackage, rhs: AlertPackage) -> Bool {
      lhs.id == rhs.id
    }
  }
}

extension AlertService.AlertPackage {
  struct Button: Sendable {
    enum Role {
      case `default`
      case cancel
      case destructive
    }
    
    let role: Role
    let title: String
    let action: (@MainActor @Sendable () -> Void)?
    
    static func `default`(_ title: String, action: (@MainActor @Sendable () -> Void)?) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .default, title: title, action: action)
    }
    
    static func cancel(_ title: String = "Cancel", action: (@MainActor @Sendable () -> Void)? = nil) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .cancel, title: title, action: action)
    }
    
    static func destructive(_ title: String, action: (@MainActor @Sendable () -> Void)?) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .destructive, title: title, action: action)
    }
  }
}
