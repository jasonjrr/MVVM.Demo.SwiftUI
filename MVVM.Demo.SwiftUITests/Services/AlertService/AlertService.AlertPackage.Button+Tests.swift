//
//  AlertService.AlertPackage.Button+Tests.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 3/14/22.
//

import XCTest
@testable import MVVM_Demo_SwiftUI

class AlertServiceAlertPackageButtonTest: XCTestCase {
  var subject: AlertService.AlertPackage.Button!
}

class AlertServiceAlertPackageButton_when_constructed: AlertServiceAlertPackageButtonTest {
  
  var expectedRole: AlertService.AlertPackage.Button.Role!
  var expectedTitle: String!
  var expectedAction: (() -> Void)?
  
  override func setUp() {
    super.setUp()
    
    self.expectedRole = .default
    self.expectedTitle = "test.title"
    self.expectedAction = nil
    
    self.subject = AlertService.AlertPackage.Button(
      role: self.expectedRole,
      title: self.expectedTitle,
      action: self.expectedAction)
  }
  
  func test_then_role_is_expected() {
    XCTAssertEqual(self.subject.role, self.expectedRole)
  }
  
  func test_then_title_is_expected() {
    XCTAssertEqual(self.subject.title, self.expectedTitle)
  }
  
  func test_then_action_is_expected() {
    XCTAssertEqual(self.subject.action == nil, self.expectedAction == nil)
  }
}

class AlertServiceAlertPackageButton_when_default_button_is_created: AlertServiceAlertPackageButtonTest {
  var expectedTitle: String!
  var expectedAction: (() -> Void)?
  
  override func setUp() {
    super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedAction = nil
    
    self.subject = .default(
      self.expectedTitle,
      action: self.expectedAction)
  }
  
  func test_then_role_is_default() {
    XCTAssertEqual(self.subject.role, .default)
  }
  
  func test_then_title_is_expected() {
    XCTAssertEqual(self.subject.title, self.expectedTitle)
  }
  
  func test_then_action_is_expected() {
    XCTAssertEqual(self.subject.action == nil, self.expectedAction == nil)
  }
}

class AlertServiceAlertPackageButton_when_cancel_button_is_created: AlertServiceAlertPackageButtonTest {
  var expectedTitle: String!
  var expectedAction: (() -> Void)?
  
  override func setUp() {
    super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedAction = nil
    
    self.subject = .cancel(
      self.expectedTitle,
      action: self.expectedAction)
  }
  
  func test_then_role_is_cancel() {
    XCTAssertEqual(self.subject.role, .cancel)
  }
  
  func test_then_title_is_expected() {
    XCTAssertEqual(self.subject.title, self.expectedTitle)
  }
  
  func test_then_action_is_expected() {
    XCTAssertEqual(self.subject.action == nil, self.expectedAction == nil)
  }
}

class AlertServiceAlertPackageButton_when_destructive_button_is_created: AlertServiceAlertPackageButtonTest {
  var expectedTitle: String!
  var expectedAction: (() -> Void)?
  
  override func setUp() {
    super.setUp()
    
    self.expectedTitle = "test.title"
    self.expectedAction = nil
    
    self.subject = .destructive(
      self.expectedTitle,
      action: self.expectedAction)
  }
  
  func test_then_role_is_cancel() {
    XCTAssertEqual(self.subject.role, .destructive)
  }
  
  func test_then_title_is_expected() {
    XCTAssertEqual(self.subject.title, self.expectedTitle)
  }
  
  func test_then_action_is_expected() {
    XCTAssertEqual(self.subject.action == nil, self.expectedAction == nil)
  }
}
