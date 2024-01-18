//
//  AlertService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

// MARK: AlertManager
@Observable
public class AlertManager: Equatable {
  var alert: AlertService.AlertPackage? {
    didSet { self.alert$.send(self.alert) }
  }
  let alert$: CurrentValueSubject<AlertService.AlertPackage?, Never> = CurrentValueSubject(nil)
  
  static public func ==(lhs: AlertManager, rhs: AlertManager) -> Bool {
    lhs === rhs
  }
}

// MARK: AlertServiceProtocol
protocol AlertServiceProtocol: AnyObject {
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

class AlertService: AlertServiceProtocol {
  private let manager: AlertManager
  
  init(alertManager: AlertManager) {
    self.manager = alertManager
  }
  
  func present(title: String, message: String?, dismissButton: AlertService.AlertPackage.Button?) {
    let alert = AlertPackage(title: title, message: message, dismissButton: dismissButton)
    DispatchQueue.main.async {
      self.manager.alert = alert
    }
  }
  
  func present(title: String, message: String?, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) {
    let alert = AlertPackage(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
    DispatchQueue.main.async {
      self.manager.alert = alert
    }
  }
}

extension AlertService {
  struct AlertPackage: Identifiable, Equatable {
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
  struct Button {
    enum Role {
      case `default`
      case cancel
      case destructive
    }
    
    let role: Role
    let title: String
    let action: (() -> Void)?
    
    static func `default`(_ title: String, action: (() -> Void)?) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .default, title: title, action: action)
    }
    
    static func cancel(_ title: String = "Cancel", action: (() -> Void)? = nil) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .cancel, title: title, action: action)
    }
    
    static func destructive(_ title: String, action: (() -> Void)?) -> AlertService.AlertPackage.Button {
      AlertService.AlertPackage.Button(role: .destructive, title: title, action: action)
    }
  }
}
