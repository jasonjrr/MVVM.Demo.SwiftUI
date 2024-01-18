//
//  AlertService+Tests.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 3/14/22.
//

import XCTest
@testable import MVVM_Demo_SwiftUI

class AlertServiceTest: XCTestCase {
  var alertManager = AlertManager()
  var subject: AlertService!
  
  override func setUp() async throws {
    try await super.setUp()
    self.subject = AlertService(alertManager: self.alertManager)
  }
}

class AlertService_when_buildAlert_title_message_dismissButton_and_dismissButton_is_nil_is_called: AlertServiceTest {
  
  var actualAlertPackage: AlertService.AlertPackage!
  
  var expectedTitle: String!
  var expectedMessage: String!
  
  override func setUp() async throws {
    try await super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedMessage = "test.message"
    
    var iterator = self.alertManager.alert$
      .compactMap { $0 }
      .values
      .makeAsyncIterator()
    
    self.subject.present(
      title: self.expectedTitle,
      message: self.expectedMessage,
      dismissButton: nil)
    
    self.actualAlertPackage = await iterator.next()
  }
  
  func test_then_package_title_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.title, self.expectedTitle)
  }
  
  func test_then_package_message_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.message, self.expectedMessage)
  }
  
  func test_then_primaryButton_role_is_cancel() {
    let isCancelType: Bool
    
    switch self.actualAlertPackage.primaryButton.role {
    case .cancel:
      isCancelType = true
    default:
      isCancelType = false
    }
    
    XCTAssertTrue(isCancelType)
  }
  
  func test_then_primaryButton_title_is_Cancel() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.title, "Cancel")
  }
  
  func test_then_primaryButton_action_is_nil() {
    XCTAssertNil(self.actualAlertPackage.primaryButton.action)
  }
}

class AlertService_when_buildAlert_title_message_dismissButton_and_dismissButton_is_not_nil: AlertServiceTest {
  
  var actualAlertPackage: AlertService.AlertPackage!
  
  var expectedTitle: String!
  var expectedMessage: String!
  var expectedButton: AlertService.AlertPackage.Button!
  
  override func setUp() async throws {
    try await super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedMessage = "test.message"
    self.expectedButton = AlertService.AlertPackage.Button(
      role: .default,
      title: "button.title",
      action: nil)
    
    var iterator = self.alertManager.alert$
      .compactMap { $0 }
      .values
      .makeAsyncIterator()
    
    self.subject.present(
      title: self.expectedTitle,
      message: self.expectedMessage,
      dismissButton: self.expectedButton)
    
    self.actualAlertPackage = await iterator.next()
  }
  
  func test_then_package_title_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.title, self.expectedTitle)
  }
  
  func test_then_package_message_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.message, self.expectedMessage)
  }
  
  func test_then_primaryButton_role_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.role, self.expectedButton.role)
  }
  
  func test_then_primaryButton_title_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.title, self.expectedButton.title)
  }
  
  func test_then_primaryButton_action_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.action == nil, self.expectedButton.action == nil)
  }
}

class AlertService_when_buildAlert_title_message_primaryButton_secondaryButton_is_called: AlertServiceTest {
  
  var actualAlertPackage: AlertService.AlertPackage!
  
  var expectedTitle: String!
  var expectedMessage: String!
  var expectedPrimaryButton: AlertService.AlertPackage.Button!
  var expectedSecondaryButton: AlertService.AlertPackage.Button!
  
  override func setUp() async throws {
    try await super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedMessage = "test.message"
    
    self.expectedPrimaryButton = AlertService.AlertPackage.Button(
      role: .cancel,
      title: "button.title.primary",
      action: nil)
    
    self.expectedSecondaryButton = AlertService.AlertPackage.Button(
      role: .default,
      title: "button.title.secondary",
      action: nil)
    
    var iterator = self.alertManager.alert$
      .compactMap { $0 }
      .values
      .makeAsyncIterator()
    
    self.subject.present(
      title: self.expectedTitle,
      message: self.expectedMessage,
      primaryButton: self.expectedPrimaryButton,
      secondaryButton: self.expectedSecondaryButton)
    
    self.actualAlertPackage = await iterator.next()
  }
  
  func test_then_package_title_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.title, self.expectedTitle)
  }
  
  func test_then_package_message_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.message, self.expectedMessage)
  }
  
  func test_then_primaryButton_role_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.role, self.expectedPrimaryButton.role)
  }
  
  func test_then_primaryButton_title_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.title, self.expectedPrimaryButton.title)
  }
  
  func test_then_primaryButton_action_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.primaryButton.action == nil, self.expectedPrimaryButton.action == nil)
  }
  
  func test_then_secondaryButton_role_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.secondaryButton?.role, self.expectedSecondaryButton.role)
  }
  
  func test_then_secondaryButton_title_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.secondaryButton?.title, self.expectedSecondaryButton.title)
  }
  
  func test_then_secondaryButton_action_is_expected() {
    XCTAssertEqual(self.actualAlertPackage.secondaryButton?.action == nil, self.expectedSecondaryButton.action == nil)
  }
}
