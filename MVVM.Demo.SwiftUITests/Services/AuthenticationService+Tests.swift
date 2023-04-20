//
//  AuthenticationService+Tests.swift
//  MVVM.Demo.SwiftUITests
//
//  Created by Jason Lew-Rapai on 12/23/21.
//

import Foundation
@testable import MVVM_Demo_SwiftUI
import XCTest
import Combine
import CombineExt
import BusyIndicator

class AuthenticationServiceTest: XCTestCase {
  var subject: AuthenticationService!
  
  override func setUp() {
    super.setUp()
    self.subject = AuthenticationService(busyIndicatorService: BusyIndicatorService())
  }
}

class AuthenticationService_when_initialized: AuthenticationServiceTest {
  func test_then_user_is_nil() async {
    let results = await self.subject.user.awaitResults(1)
    XCTAssertEqual(results?[0], .success(nil))
  }
  
  func test_then_isAuthenticated_is_false() async {
    let results = await self.subject.isAuthenticated.awaitResults(1)
    XCTAssertEqual(results?[0], .success(false))
  }
}

class AuthenticationService_when_a_user_signs_in: AuthenticationServiceTest {
  var expectedUsername: String!
  var expectedPassword: String!
  
  var signinPublisher: AnyPublisher<User, Error>!
  
  override func setUp() {
    super.setUp()
  
    self.expectedUsername = "test.user.name"
    self.expectedPassword = "test.password"
    
    self.signinPublisher = self.subject
      .signIn(username: self.expectedUsername, password: self.expectedPassword)
      .share()
      .eraseToAnyPublisher()
  }
  
  func test_then_emitted_user_is_not_nil() async {
    let results = await self.signinPublisher.awaitResults(1)
    XCTAssertNotNil(results?.first?.value)
  }
  
  func test_then_emitted_user_has_expected_username() async {
    let results = await self.signinPublisher.awaitResults(1)
    XCTAssertEqual(results?.first?.value?.username, self.expectedUsername)
  }
  
  func test_then_emitted_user_has_expected_password() async {
    let results = await self.signinPublisher.awaitResults(1)
    XCTAssertEqual(results?.first?.value?.password, self.expectedPassword)
  }
  
  func test_then_user_is_not_nil() async {
    let _ = await self.signinPublisher.awaitResults(1)
    let results = await self.subject.user.awaitResults(1)
    XCTAssertNotEqual(results?[0], .success(nil))
  }
  
  func test_then_isAuthenticated_is_true() async {
    let _ = await self.signinPublisher.awaitResults(1)
    let results = await self.subject.isAuthenticated.awaitResults(1)
    XCTAssertEqual(results?[0], .success(true))
  }
}

class AuthenticationService_when_a_user_signs_out_after_signing_in: AuthenticationServiceTest {
  var expectedUsername: String!
  var expectedPassword: String!
  
  var signInPublisher: AnyPublisher<User, Error>!
  var signOutPublisher: AnyPublisher<Void, Error>!
  
  override func setUp() {
    super.setUp()
  
    self.expectedUsername = "test.user.name"
    self.expectedPassword = "test.password"
    
    self.signInPublisher = self.subject
      .signIn(username: self.expectedUsername, password: self.expectedPassword)
    
    self.signOutPublisher = self.subject
      .signOut()
  }
  
  func test_then_success_is_emitted() async {
    let _ = await self.signInPublisher.awaitResults(1)
    let results = await self.signOutPublisher.awaitResults(1)
    XCTAssertTrue(results?[0].isSuccess ?? false)
  }
  
  func test_then_user_emits_nil() async {
    let _ = await self.signInPublisher.awaitResults(1)
    let _ = await self.signOutPublisher.awaitResults(1)
    
    let results = await self.subject.user
      .awaitResults(1)
    
    XCTAssertEqual(results?.first, .success(nil))
  }
}
