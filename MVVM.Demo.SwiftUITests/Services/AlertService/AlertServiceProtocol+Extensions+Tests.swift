//
//  AlertServiceProtocol+Extensions+Tests.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 3/15/22.
//

import XCTest
@testable import MVVM_Demo_SwiftUI

fileprivate final class TestAlertServiceProtocol: AlertServiceProtocol {
  private(set) var buildAlertTitleMessageDismissButtonCallCount: Int = 0
  
  func buildAlert(title: String, message: String?, dismissButton: AlertService.AlertPackage.Button?) -> AlertService.AlertPackage {
    self.buildAlertTitleMessageDismissButtonCallCount += 1
    
    return AlertService.AlertPackage(title: title, message: message, dismissButton: dismissButton)
  }
  
  private(set) var buildAlertTitleMessagePrimaryButtonSecondaryButtonCallCount: Int = 0
  
  func buildAlert(title: String, message: String?, primaryButton: AlertService.AlertPackage.Button, secondaryButton: AlertService.AlertPackage.Button) -> AlertService.AlertPackage {
    self.buildAlertTitleMessagePrimaryButtonSecondaryButtonCallCount += 1
    
    return AlertService.AlertPackage(title: title, message: message, primaryButton: primaryButton, secondaryButton: secondaryButton)
  }
}

class AlertServiceProtocol_Extensions_Test: XCTestCase {
  fileprivate var subject: TestAlertServiceProtocol!
  
  override func setUp() {
    super.setUp()
    
    self.subject = TestAlertServiceProtocol()
  }
}

class AlertServiceProtocol_Extensions_when_buildAlert_with_only_title_is_called: AlertServiceProtocol_Extensions_Test {
  
  var expectedTitle: String!
  var actualPackage: AlertService.AlertPackage!
  
  override func setUp() {
    super.setUp()
    
    self.expectedTitle = "test.title"
    self.actualPackage = self.subject.buildAlert(title: self.expectedTitle)
  }
  
  func test_then_call_count_is_1() {
    XCTAssertEqual(self.subject.buildAlertTitleMessageDismissButtonCallCount, 1)
  }
  
  func test_then_package_message_is_nil() {
    XCTAssertNil(self.actualPackage.message)
  }
  
  func test_then_primaryButton_role_is_cancel() {
    XCTAssertEqual(self.actualPackage.primaryButton.role, .cancel)
  }
  
  func test_then_primaryButton_action_is_nil() {
    XCTAssertNil(self.actualPackage.primaryButton.action)
  }
  
  func test_then_primaryButton_title_is_Cancel() {
    XCTAssertEqual(self.actualPackage.primaryButton.title, "Cancel")
  }
  
  func test_then_secondaryButton_is_nil() {
    XCTAssertNil(self.actualPackage.secondaryButton)
  }
}

class AlertServiceProtocol_Extensions_when_buildAlert_with_only_title_primaryButton_secondaryButton_is_called: AlertServiceProtocol_Extensions_Test {
  
  var expectedTitle: String!
  var expectedPrimaryButton: AlertService.AlertPackage.Button!
  var expectedSecondaryButton: AlertService.AlertPackage.Button!
  var actualPackage: AlertService.AlertPackage!
  
  override func setUp() {
    super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedPrimaryButton = AlertService.AlertPackage.Button(
      role: .destructive,
      title: "test.primary.title",
      action: nil)
    self.expectedSecondaryButton = AlertService.AlertPackage.Button(
      role: .default,
      title: "test.secondary.title",
      action: nil)
    
    self.actualPackage = self.subject.buildAlert(
      title: self.expectedTitle,
      primaryButton: self.expectedPrimaryButton,
      secondaryButton: self.expectedSecondaryButton)
  }
  
  func test_then_call_count_is_1() {
    XCTAssertEqual(self.subject.buildAlertTitleMessagePrimaryButtonSecondaryButtonCallCount, 1)
  }
  
  func test_then_package_message_is_nil() {
    XCTAssertNil(self.actualPackage.message)
  }
  
  func test_then_primaryButton_role_is_expected() {
    XCTAssertEqual(self.actualPackage.primaryButton.role, self.expectedPrimaryButton.role)
  }
  
  func test_then_primaryButton_action_is_expected() {
    XCTAssertEqual(self.actualPackage.primaryButton.action == nil, self.expectedPrimaryButton.action == nil)
  }
  
  func test_then_primaryButton_title_is_expected() {
    XCTAssertEqual(self.actualPackage.primaryButton.title, self.expectedPrimaryButton.title)
  }
  
  func test_then_secondaryButton_role_is_expected() {
    XCTAssertEqual(self.actualPackage.secondaryButton?.role, self.expectedSecondaryButton.role)
  }
  
  func test_then_secondaryButton_action_is_expected() {
    XCTAssertEqual(self.actualPackage.secondaryButton?.action == nil, self.expectedSecondaryButton.action == nil)
  }
  
  func test_then_secondaryButton_title_is_expected() {
    XCTAssertEqual(self.actualPackage.secondaryButton?.title, self.expectedSecondaryButton.title)
  }
}
