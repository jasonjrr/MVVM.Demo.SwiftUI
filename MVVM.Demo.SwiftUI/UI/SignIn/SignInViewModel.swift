//
//  SignInViewModel.swift
//  MVVM.Demo.SwiftUI
//
//  Created by Jason Lew-Rapai on 11/15/21.
//

import Foundation
import Combine

@Observable @MainActor
final class SignInViewModel: ViewModel {
  @ObservationIgnored private let authenticationService: AuthenticationServiceProtocol
  
  @ObservationIgnored private weak var delegate: Delegate?
  
  var username: String = .empty
  var password: String = .empty
  
  var canSignIn: Bool {
    !self.username.isEmpty && !self.password.isEmpty
  }
  
  @ObservationIgnored private var signInCancellable: AnyCancellable?
  
  init(authenticationService: AuthenticationServiceProtocol) {
    self.authenticationService = authenticationService
  }
  
  @discardableResult
  func setup(delegate: Delegate) -> Self {
    self.delegate = delegate
    return self
  }
  
  func cancel() {
    self.endEditing()
    self.delegate?.signInViewModelDidCancel(self)
  }
  
  func signIn() {
    guard self.canSignIn else { return }
    
    // Replacing the cancellable cancels any sign in still in flight.
    self.signInCancellable = self.authenticationService
      .signIn(username: self.username, password: self.password)
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        guard let self = self else { return }
        self.delegate?.signInViewModelDidSignIn(self)
      })
  }
}

extension SignInViewModel {
  @MainActor protocol Delegate: AnyObject {
    func signInViewModelDidCancel(_ source: SignInViewModel)
    func signInViewModelDidSignIn(_ source: SignInViewModel)
  }
}
