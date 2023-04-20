//
//  AuthenticationService.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine
import CombineExt
import SwiftUI
import BusyIndicator

protocol AuthenticationServiceProtocol: AnyObject {
  var user: AnyPublisher<User?, Never> { get }
  var isAuthenticated: AnyPublisher<Bool, Never> { get }
  
  func signIn(username: String, password: String) -> AnyPublisher<User, Error>
  func signOut() -> AnyPublisher<Void, Error>
  func signOutAsync()
}

class AuthenticationService: AuthenticationServiceProtocol {
  private let busyIndicatorService: BusyIndicatorServiceProtocol
  
  private let _user: CurrentValueSubject<User?, Never> = CurrentValueSubject(nil)
  var user: AnyPublisher<User?, Never> { self._user.eraseToAnyPublisher() }
  
  lazy private(set) var isAuthenticated: AnyPublisher<Bool, Never> = self._user
    .map { return $0 != nil }
    .share(replay: 1)
    .eraseToAnyPublisher()
  
  private var cancelBag = CancelBag()
  
  init(busyIndicatorService: BusyIndicatorServiceProtocol) {
    self.busyIndicatorService = busyIndicatorService
  }
  
  func signIn(username: String, password: String) -> AnyPublisher<User, Error> {
    let user = User(username: username, password: password)
    self._user.send(user)
    return self._user
      .prefix(1)
      .setFailureType(to: Error.self)
      .flatMapLatest { (newUser: User?) -> AnyPublisher<User, Error> in
        if newUser == user {
          return Just(user)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        } else {
          return Fail(error: Errors.userIsOutOfSync)
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
  
  func signOut() -> AnyPublisher<Void, Error> {
    let busySubject = self.busyIndicatorService.enqueue()
    self._user.send(nil)
    return self._user
      .prefix(1)
      .setFailureType(to: Error.self)
      // This delay is to the the BusyIndicator at work.
      .delay(for: 3.0, scheduler: DispatchQueue.global(qos: .userInitiated))
      .flatMapLatest { (newUser: User?) -> AnyPublisher<Void, Error> in
        defer { busySubject.dequeue() }
        if newUser == nil {
          return Just()
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        } else {
          return Fail(error: Errors.userIsOutOfSync)
            .eraseToAnyPublisher()
        }
      }
      .eraseToAnyPublisher()
  }
  
  func signOutAsync() {
    self.signOut()
      .debug("## signout")
      .sink()
      .store(in: &self.cancelBag)
  }
}

extension AuthenticationService {
  enum Errors: Error {
    case userIsOutOfSync
  }
}

struct User: Equatable {
  let username: String
  let password: String
  
  static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.username == rhs.username
    && lhs.password == rhs.password
  }
}
