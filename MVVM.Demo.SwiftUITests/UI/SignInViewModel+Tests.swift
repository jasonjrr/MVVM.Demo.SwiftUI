//
//  SignInViewModel+Tests.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 11/9/26.
//

import XCTest
import BusyIndicator
@testable import MVVM_Demo_SwiftUI

@MainActor
final class SignInViewModelDelegateMock: SignInViewModel.Delegate {
  var didCancelCount: Int = 0
  var onDidSignIn: (() -> Void)?
  
  func signInViewModelDidCancel(_ source: SignInViewModel) {
    self.didCancelCount = self.didCancelCount + 1
  }
  
  func signInViewModelDidSignIn(_ source: SignInViewModel) {
    self.onDidSignIn?()
  }
}

@MainActor
class SignInViewModelTest: XCTestCase {
  var delegate: SignInViewModelDelegateMock!
  var subject: SignInViewModel!
  
  override func setUp() async throws {
    try await super.setUp()
    self.delegate = SignInViewModelDelegateMock()
    self.subject = SignInViewModel(
      authenticationService: AuthenticationService(busyIndicatorService: BusyIndicatorService()))
    self.subject.setup(delegate: self.delegate)
  }
}

class SignInViewModel_when_initialized: SignInViewModelTest {
  func test_then_canSignIn_is_false() {
    XCTAssertFalse(self.subject.canSignIn)
  }
}

class SignInViewModel_when_only_the_username_is_set: SignInViewModelTest {
  override func setUp() async throws {
    try await super.setUp()
    self.subject.username = "test.user.name"
  }
  
  func test_then_canSignIn_is_false() {
    XCTAssertFalse(self.subject.canSignIn)
  }
}

class SignInViewModel_when_the_username_and_password_are_set: SignInViewModelTest {
  override func setUp() async throws {
    try await super.setUp()
    self.subject.username = "test.user.name"
    self.subject.password = "test.password"
  }
  
  func test_then_canSignIn_is_true() {
    XCTAssertTrue(self.subject.canSignIn)
  }
  
  func test_then_signIn_notifies_the_delegate() async {
    let didSignIn = expectation(description: "delegate notified of sign in")
    self.delegate.onDidSignIn = { didSignIn.fulfill() }
    
    self.subject.signIn()
    
    await fulfillment(of: [didSignIn], timeout: 5.0)
  }
}

class SignInViewModel_when_cancel_is_called: SignInViewModelTest {
  override func setUp() async throws {
    try await super.setUp()
    self.subject.cancel()
  }
  
  func test_then_the_delegate_is_notified_once() {
    XCTAssertEqual(self.delegate.didCancelCount, 1)
  }
}
